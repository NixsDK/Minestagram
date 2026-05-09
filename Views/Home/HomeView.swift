//
//  HomeView.swift
//  Minestagram
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedPhoto: AlbumPhoto?

    private let gridSpacing = MinestagramTheme.gridSpacing
    private var gridColumns: [GridItem] {
        [
            GridItem(.flexible(), spacing: gridSpacing),
            GridItem(.flexible(), spacing: gridSpacing),
            GridItem(.flexible(), spacing: gridSpacing)
        ]
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                profileSection
                photoGridSection
            }
            .padding(.vertical)
        }
        .background(Color(.systemBackground))
        .navigationTitle("Minestagram")
        .navigationBarTitleDisplayMode(.large)
        .minestagramNavigationChrome()
        .task {
            await viewModel.load()
        }
        .navigationDestination(item: $selectedPhoto) { photo in
            GridPhotoDetailView(photo: photo)
        }
    }

    @ViewBuilder
    private var profileSection: some View {
        if let user = viewModel.user {
            ProfileHeaderView(user: user)
                .padding(.horizontal)
        } else if viewModel.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity)
                .padding()
        } else if let message = viewModel.errorMessage {
            Text(message)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
        }
    }

    @ViewBuilder
    private var photoGridSection: some View {
        LazyVGrid(columns: gridColumns, spacing: gridSpacing) {
            ForEach(viewModel.photos) { photo in
                gridCell(for: photo)
            }
        }
        .padding(.horizontal, gridSpacing)
    }

    @ViewBuilder
    private func gridCell(for photo: AlbumPhoto) -> some View {
        Button {
            selectedPhoto = photo
        } label: {
            // Square tiles: equal column width from `GridItem.flexible`, 1:1 aspect, clip overflow.
            AsyncImage(url: photo.reliableThumbnailURL) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Color(.secondarySystemFill)
                        ProgressView()
                    }
                case let .success(image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    Image(systemName: "photo")
                        .foregroundStyle(.secondary)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fill)
            .clipped()
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(photo.title ?? "Photo"))
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
