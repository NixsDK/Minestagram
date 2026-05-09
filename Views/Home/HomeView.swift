//
//  HomeView.swift
//  Minestagram
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedPhoto: AlbumPhoto?

    private let gridColumns = [
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4)
    ]

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
        .navigationBarTitleDisplayMode(.inline)
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
        LazyVGrid(columns: gridColumns, spacing: 4) {
            ForEach(viewModel.photos) { photo in
                gridCell(for: photo)
            }
        }
        .padding(.horizontal, 4)
    }

    @ViewBuilder
    private func gridCell(for photo: AlbumPhoto) -> some View {
        Button {
            selectedPhoto = photo
        } label: {
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
            .frame(minHeight: 110)
            .clipped()
            .aspectRatio(1, contentMode: .fill)
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
