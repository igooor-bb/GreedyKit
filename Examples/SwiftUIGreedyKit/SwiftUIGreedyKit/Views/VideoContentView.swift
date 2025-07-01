//
//  VideoContentView.swift
//  SwiftUIGreedyKit
//
//  Created by Igor Belov on 11.09.2022.
//

import AVFoundation
import GreedyKit
import SwiftUI

struct VideoContentView: View {
    private var localVideo: AVAsset = {
        guard let url = Bundle.main.url(forResource: "video", withExtension: "mp4") else {
            fatalError("Test video is missing in the bundle")
        }
        return AVAsset(url: url)
    }()

    @State private var preventsCapture: Bool = false
    private let player: AVPlayer
    private let playerItem: AVPlayerItem

    init() {
        self.playerItem = AVPlayerItem(asset: localVideo)
        self.player = AVPlayer()
    }

    var body: some View {
        VStack {
            GreedyPlayer(
                player,
                preventsCapture: preventsCapture
            )

            Toggle(isOn: $preventsCapture) {
                Text("Protection is " + (preventsCapture ? "ON" : "OFF"))
            }
        }
        .onAppear {
            player.replaceCurrentItem(with: playerItem)
            player.seek(to: .zero)
            player.play()
        }
        .onDisappear {
            player.replaceCurrentItem(with: nil)
        }
        .padding(16)
    }
}

struct VideoContentView_Previews: PreviewProvider {
    static var previews: some View {
        VideoContentView()
    }
}
