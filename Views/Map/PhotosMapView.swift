//
//  PhotosMapView.swift
//  Minestagram
//

import MapKit
import SwiftUI

struct PhotosMapView: View {
    @StateObject private var viewModel = MapViewModel()
    @StateObject private var locationManager = LocationManager()
    @State private var mapSelection: UUID?
    @Environment(\.openURL) private var openURL

    var body: some View {
        Map(selection: $mapSelection) {
            ForEach(viewModel.annotations) { pin in
                Marker(pin.title, coordinate: pin.coordinate)
                    .tint(MinestagramTheme.accentGold)
                    .tag(pin.id)
            }
            UserAnnotation()
        }
        .mapStyle(.standard(elevation: .realistic))
        .onAppear {
            locationManager.requestWhenInUse()
            viewModel.refreshAnnotations()
        }
        .onChange(of: mapSelection) { _, newValue in
            guard let newValue,
                  let pin = viewModel.annotations.first(where: { $0.id == newValue })
            else {
                return
            }
            viewModel.userSelectedPinForDirections(pin)
        }
        .onChange(of: viewModel.showDirectionsDialog) { _, isPresented in
            if !isPresented {
                mapSelection = nil
            }
        }
        .confirmationDialog(
            "Open directions?",
            isPresented: $viewModel.showDirectionsDialog,
            titleVisibility: .visible
        ) {
            Button("Open in Apple Maps") {
                if let pin = viewModel.selectedPin {
                    openURL(viewModel.mapsDirectionsURL(for: pin))
                }
            }
            Button("Cancel", role: .cancel) {
                viewModel.selectedPin = nil
            }
        } message: {
            Text("Uses maps:// with your destination coordinates.")
        }
        .navigationTitle("Map")
        .navigationBarTitleDisplayMode(.large)
        .minestagramNavigationChrome()
        .minestagramThemeToolbar()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.refreshAnnotations()
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .accessibilityLabel(Text("Refresh pins"))
            }
        }
        .safeAreaInset(edge: .bottom) {
            mapLegend
        }
        .refreshable {
            viewModel.refreshAnnotations()
        }
    }

    @ViewBuilder
    private var mapLegend: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Pins come from GPS metadata in cached photos. JSONPlaceholder images usually have no GPS—add a geotagged photo to the cache to see markers.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
    }
}

#Preview {
    NavigationStack {
        PhotosMapView()
    }
}
