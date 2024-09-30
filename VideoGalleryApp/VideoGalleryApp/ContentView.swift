//
//  ContentView.swift
//  VideoGalleryApp
//
//  Created by Ichsan Indra Wahyudi on 29/09/24.
//

import AlertToast
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = VideoViewModel()
    
    @State private var isShowToast = false
    @State private var selectedVideo: Video?
    @State private var showAlert = false
    @State private var isShowRecorderView = false
    @State private var deletedVideo: Video?
    
    var body: some View {
        NavigationView {
            switch viewModel.state {
            case .loading:
                VStack {
                    ProgressView()
                }
                
            case let .success(data):
                ZStack {
                    // List of videos
                    List {
                        ForEach(data) { video in
                            if let url = URL(string: video.secureURL) {
                                VideoThumbnailView(url: url)
                                    .onTapGesture {
                                        selectedVideo = video
                                    }
                                    .swipeActions {
                                        Button(role: .destructive) {
                                            deletedVideo = video
                                            showAlert = true
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                    }
                    .refreshable {
                        viewModel.getVideos()
                    }
                    
                    // Floating button
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                isShowRecorderView = true
                            }) {
                                Image(systemName: "camera")
                                    .frame(width: 32, height: 32)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                            }
                            .padding()
                        }
                    }
                }
                .navigationTitle("Videos")
                
            case let .error(string):
                ContentUnavailableView(label: {
                    Text("Error")
                }, description: {
                    Text(string)
                }, actions: {
                    Button(action: {
                        viewModel.getVideos()
                    }, label: {
                        Text("Try Again")
                    })
                })
            }
            
        }
       
        .onAppear {
            viewModel.getVideos()
        }
        .sheet(item: $selectedVideo, content: { video in
            if let url = URL(string: video.secureURL) {
                FullScreenVideoPlayerView(url: url)
            }
        })
        .fullScreenCover(isPresented: $isShowRecorderView, content: {
            VideoRecorderView()
        })
        .alert(isPresented: $showAlert, content: {
            Alert(
                title: Text("Delete Video"),
                message: Text("Are you sure you want to delete?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let deletedVideo {
                        viewModel.deleteVideo(id: deletedVideo.publicID)
                    }
                },
                secondaryButton: .cancel()
            )
        })
        .toast(isPresenting: $viewModel.isShowingToast, alert: {
            var type: AlertToast.AlertType = .regular
            var title: String = ""
            var titleColor: Color? = .white
            var backgroundColor: Color?
            
            switch viewModel.toastState {
            case .loading:
                type = .loading
                title = "Deleting video..."
                titleColor = nil
                backgroundColor = nil
               
            case .success:
                title = "Successfully deleted the video."
                backgroundColor = .green
                
            case .error:
                title = "Failed to delete the video."
                backgroundColor = .red
                
            case .idle:
                break
            }
            
            return AlertToast(
                displayMode: .hud,
                type: type,
                title: title,
                style: .style(
                    backgroundColor: backgroundColor,
                    titleColor: titleColor,
                    subTitleColor: nil,
                    titleFont: nil,
                    subTitleFont: nil
                )
            )
        })
    }
}

#Preview {
    ContentView()
}
