//
//  FullScreenVideoPlayerView.swift
//  Minestagram
//

import AVFoundation
import AVKit
import SwiftUI

struct FullScreenVideoPlayerView: View {
    let item: VideoItem
    var onClose: () -> Void

    @State private var player: AVPlayer?

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black.ignoresSafeArea()

            if let player {
                VideoPlayer(player: player)
                    .ignoresSafeArea()
            } else {
                ProgressView()
                    .tint(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            Button(action: onClose) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.white)
                    .padding(12)
                    .background(.ultraThinMaterial, in: Circle())
            }
            .padding()
            .accessibilityLabel(Text("Close"))
        }
        .onAppear {
            try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
            try? AVAudioSession.sharedInstance().setActive(true)
            let newPlayer = AVPlayer(url: item.streamURL)
            player = newPlayer
            newPlayer.play()
        }
        .onDisappear {
            player?.pause()
            player?.replaceCurrentItem(with: nil)
            player = nil
            try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        }
    }
}

#Preview {
    FullScreenVideoPlayerView(
        item: VideoItem(
            title: "Sample",
            streamURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
        ),
        onClose: {}
    )
}
