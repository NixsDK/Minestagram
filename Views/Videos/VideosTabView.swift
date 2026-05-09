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
        .navigationBarTitleDisplayMode(.inline)
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
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(.secondarySystemGroupedBackground))
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 36))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.primary)
                }
                .frame(width: 88, height: 62)

                VStack(alignment: .leading, spacing: 6) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                    Text("Tap to play full screen")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(Color(.separator), lineWidth: 0.5)
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
