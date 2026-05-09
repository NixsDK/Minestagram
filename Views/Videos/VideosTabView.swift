//
//  VideosTabView.swift
//  Minestagram
//

import SwiftUI

struct VideosTabView: View {
    @StateObject private var viewModel = VideosViewModel()
    @State private var activeVideo: VideoItem?

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                ForEach(viewModel.items) { item in
                    videoCard(item)
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Videos")
        .navigationBarTitleDisplayMode(.large)
        .minestagramNavigationChrome()
        .onAppear {
            viewModel.load()
        }
        .fullScreenCover(item: $activeVideo) { item in
            FullScreenVideoPlayerView(item: item) {
                activeVideo = nil
            }
        }
    }

    @ViewBuilder
    private func videoCard(_ item: VideoItem) -> some View {
        Button {
            activeVideo = item
        } label: {
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .fill(MinestagramTheme.brandYellow)
                    .frame(width: 5)

                Image(systemName: "play.circle.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(MinestagramTheme.brandYellow)
                    .padding(.leading, 14)

                VStack(alignment: .leading, spacing: 6) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                    Text("Tap to play full screen")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.leading, 12)

                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
                    .padding(.trailing, 4)
            }
            .padding(.vertical, 14)
            .padding(.trailing, 12)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(Color(.separator).opacity(0.35), lineWidth: 0.5)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        VideosTabView()
    }
}
