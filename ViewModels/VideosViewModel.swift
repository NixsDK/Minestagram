//
//  VideosViewModel.swift
//  Minestagram
//

import Foundation

@MainActor
final class VideosViewModel: ObservableObject {
    @Published private(set) var items: [VideoItem] = []

    func load() {
        // Mix of Apple HLS + smaller MP4s — simulates reliably; old GTV bucket clips sometimes stall on iOS.
        items = [
            VideoItem(
                title: "Apple sample stream (HLS)",
                streamURL: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8")!
            ),
            VideoItem(
                title: "Big Buck Bunny (short MP4)",
                streamURL: URL(string: "https://storage.googleapis.com/exoplayer-test-media-0/BigBuckBunny_320x180.mp4")!
            ),
            VideoItem(
                title: "Apple BipBop 16×9 stream (HLS)",
                streamURL: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8")!
            )
        ]
    }
}
