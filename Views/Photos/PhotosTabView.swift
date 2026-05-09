//
//  PhotosTabView.swift
//  Minestagram
//

import SwiftUI

struct PhotosTabView: View {
    @StateObject private var viewModel = PhotosViewModel()
    @State private var selectedPost: PhotoPost?

    var body: some View {
        ZStack {
            Group {
                if viewModel.posts.isEmpty, !viewModel.isLoadingMetadata, viewModel.errorMessage != nil {
                    ContentUnavailableView(
                        "No cached posts",
                        systemImage: "wifi.slash",
                        description: Text(viewModel.errorMessage ?? "")
                    )
                } else {
                    List {
                        ForEach(viewModel.posts) { post in
                            Button {
                                guard post.localImageURL != nil else { return }
                                selectedPost = post
                            } label: {
                                PhotoPostRowView(post: post)
                            }
                            .buttonStyle(.plain)
                            .disabled(post.localImageURL == nil)
                            .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                }
            }

            if viewModel.isLoadingMetadata || viewModel.isCachingImages {
                loadingOverlay
            }
        }
        .navigationTitle("Photos")
        .navigationBarTitleDisplayMode(.large)
        .minestagramNavigationChrome()
        .navigationDestination(item: $selectedPost) { post in
            PhotoPostDetailView(post: post)
        }
        .refreshable {
            await viewModel.load()
        }
        .task {
            await viewModel.load()
        }
    }

    @ViewBuilder
    private var loadingOverlay: some View {
        VStack(spacing: 12) {
            ProgressView()
            if viewModel.isCachingImages {
                Text("Saving images \(viewModel.cachingProgress.current)/\(viewModel.cachingProgress.total)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            } else {
                Text("Loading posts…")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(24)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(radius: 8, y: 4)
    }
}

#Preview {
    NavigationStack {
        PhotosTabView()
    }
}
