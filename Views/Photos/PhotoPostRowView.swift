//
//  PhotoPostRowView.swift
//  Minestagram
//

import SwiftUI

struct PhotoPostRowView: View {
    let post: PhotoPost

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                avatar
                Text(post.username)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                Spacer(minLength: 0)
            }

            photoContent
                .frame(maxWidth: .infinity)
                .aspectRatio(4 / 3, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .padding(.vertical, 6)
    }

    @ViewBuilder
    private var avatar: some View {
        Group {
            if let assetName = post.avatarAssetName {
                Image(assetName)
                    .resizable()
                    .scaledToFill()
            } else if let avatarURL = post.avatarURL {
                AsyncImage(url: avatarURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case let .success(image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        placeholderAvatar
                    @unknown default:
                        placeholderAvatar
                    }
                }
            } else {
                placeholderAvatar
            }
        }
        .frame(width: 40, height: 40)
        .clipShape(Circle())
    }

    @ViewBuilder
    private var placeholderAvatar: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .scaledToFit()
            .foregroundStyle(.secondary)
    }

    @ViewBuilder
    private var photoContent: some View {
        if let local = post.localImageURL {
            DiskImageView(url: local)
                .scaledToFill()
        } else {
            AsyncImage(url: post.remoteImageURL) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Color(.tertiarySystemFill)
                        VStack(spacing: 6) {
                            ProgressView()
                            Text("Loading…")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                case let .success(image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    ZStack {
                        Color(.tertiarySystemFill)
                        VStack(spacing: 6) {
                            Image(systemName: "wifi.exclamationmark")
                                .imageScale(.large)
                                .foregroundStyle(.secondary)
                            Text("Could not load image")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                @unknown default:
                    Color(.tertiarySystemFill)
                }
            }
        }
    }
}

#Preview {
    List {
        PhotoPostRowView(
            post: PhotoPost(
                id: 1,
                username: "Tester",
                avatarURL: URL(string: "https://i.pravatar.cc/100"),
                avatarAssetName: nil,
                remoteImageURL: URL(string: "https://example.com/x.jpg")!,
                localImageURL: nil
            )
        )
    }
}
