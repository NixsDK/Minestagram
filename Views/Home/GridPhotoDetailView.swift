//
//  GridPhotoDetailView.swift
//  Minestagram
//

import SwiftUI

struct GridPhotoDetailView: View {
    let photo: AlbumPhoto

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                // Do not use `URL(string: photo.url)` — JSONPlaceholder hosts break on iOS; use `reliableImageURL`.
                AsyncImage(url: photo.reliableImageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 240)
                    case let .success(image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure:
                        Label("Could not load image", systemImage: "exclamationmark.triangle")
                            .foregroundStyle(.secondary)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity)

                if let title = photo.title {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .navigationTitle("Photo")
        .navigationBarTitleDisplayMode(.inline)
        .minestagramNavigationChrome()
        .minestagramThemeToolbar()
    }
}

#Preview {
    NavigationStack {
        GridPhotoDetailView(
            photo: AlbumPhoto(
                albumId: 1,
                id: 1,
                title: "Sample",
                url: "-",
                thumbnailUrl: "-"
            )
        )
    }
    .environmentObject(ThemeController())
}
