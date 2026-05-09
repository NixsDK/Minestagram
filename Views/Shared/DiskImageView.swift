//
//  DiskImageView.swift
//  Minestagram
//

import SwiftUI
import UIKit

/// Loads `UIImage` from a file URL (offline cache).
struct DiskImageView: View {
    let url: URL

    @State private var image: UIImage?

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    Color(.secondarySystemFill)
                    ProgressView()
                }
            }
        }
        .task(id: url) {
            await load()
        }
    }

    private func load() async {
        let target = url
        let loaded = await Task.detached(priority: .userInitiated) {
            (try? Data(contentsOf: target)).flatMap { UIImage(data: $0) }
        }.value
        await MainActor.run {
            image = loaded
        }
    }
}
