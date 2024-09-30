//
//  FullScreenVideoPlayerView.swift
//  VideoGalleryApp
//
//  Created by Ichsan Indra Wahyudi on 30/09/24.
//

import AVKit
import SwiftUI

struct FullScreenVideoPlayerView: View {
    let url: URL
    
    @State private var player: AVPlayer?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                player = AVPlayer(url: url)
                player?.play()
            }
            .onDisappear {
                player?.pause()
            }
            .ignoresSafeArea()
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
    }
}
