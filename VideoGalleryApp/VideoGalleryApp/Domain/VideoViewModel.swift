//
//  VideoViewModel.swift
//  VideoGalleryApp
//
//  Created by Ichsan Indra Wahyudi on 29/09/24.
//

import Foundation
import Combine

class VideoViewModel: ObservableObject {
    @Published var state: ViewState<[Video]> = .loading
    @Published var toastState: ToastState = .idle
    @Published var isShowingToast: Bool = false
    @Published var isShouldRefresh: Bool = false
    
    @Published var isError: String = ""
    
    private let videoService: VideoServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(videoService: VideoServiceProtocol = VideoService()) {
        self.videoService = videoService
    }
    
    func getVideos() {        
        videoService.getVideos()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completions in
                switch completions {
                case .finished:
                    break
                case let .failure(error):
                    self?.state = .error(error.localizedDescription)
                }
            }, receiveValue: { data in
                self.state = .success(data.videos)
            })
            .store(in: &cancellables)
    }
    

    
    func deleteVideo(id: String) {
        toastState = .loading
        isShowingToast = true
        
        videoService.deleteVideo(id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completions in
                switch completions {
                case .finished:
                    break
                case .failure:
                    self?.setToast(state: .success)
                }
            }, receiveValue: {  [weak self] _ in
                self?.getVideos()
                self?.setToast(state: .success)
            })
            .store(in: &cancellables)
    }
    
    private func setToast(state: ToastState) {
        isShowingToast = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.toastState = state
            self?.isShowingToast = true
            // Hide the toast after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.isShowingToast = false
            }
        }
    }
}

// Helper

enum ViewState<T> {
    case loading
    case success(T)
    case error(String)
}

enum ToastState {
    case idle
    case loading
    case success
    case error
}
