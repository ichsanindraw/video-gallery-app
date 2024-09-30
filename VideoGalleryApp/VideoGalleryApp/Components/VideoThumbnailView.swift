//
//  VideoThumbnailView.swift
//  VideoGalleryApp
//
//  Created by Ichsan Indra Wahyudi on 29/09/24.
//

import AVKit
import SwiftUI

struct VideoThumbnailView: View {
    let url: URL
    
    var body: some View {
        VideoPlayer(player: AVPlayer(url: url))
            .frame(height: 300)
            .cornerRadius(8)
            .padding()
    }
}
