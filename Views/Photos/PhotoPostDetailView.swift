//
//  PhotoPostDetailView.swift
//  Minestagram
//

import SwiftUI

struct PhotoPostDetailView: View {
    let post: PhotoPost

    private var exifLines: [(key: String, value: String)] {
        guard let url = post.localImageURL else { return [] }
        let dict = EXIFService.dictionaryForImage(at: url)
        return dict.keys.sorted().map { key in (key, dict[key] ?? "") }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let url = post.localImageURL {
                    DiskImageView(url: url)
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                } else {
                    unavailableView
                }

                exifSection
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var unavailableView: some View {
        ContentUnavailableView(
            "Image not cached",
            systemImage: "icloud.slash",
            description: Text("Open the Photos tab online once so images save to your device.")
        )
    }

    @ViewBuilder
    private var exifSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("EXIF & metadata")
                .font(.headline)
                .foregroundStyle(.primary)

            if exifLines.isEmpty {
                Text(post.localImageURL == nil ? "No file on disk." : "No EXIF metadata found for this JPEG/PNG.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(exifLines, id: \.key) { row in
                        exifRow(key: row.key, value: row.value)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func exifRow(key: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(key)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.footnote)
                .foregroundStyle(.primary)
                .textSelection(.enabled)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

#Preview {
    NavigationStack {
        PhotoPostDetailView(
            post: PhotoPost(
                id: 1,
                username: "You",
                avatarURL: nil,
                avatarAssetName: nil,
                remoteImageURL: URL(string: "https://example.com")!,
                localImageURL: nil
            )
        )
    }
}
