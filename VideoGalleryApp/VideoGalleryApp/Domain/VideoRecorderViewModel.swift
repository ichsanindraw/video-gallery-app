//
//  VideoRecorderViewModel.swift
//  VideoGalleryApp
//
//  Created by Ichsan Indra Wahyudi on 30/09/24.
//

import Combine
import Foundation

class VideoRecorderViewModel: ObservableObject {
    @Published var toastState: ToastState = .idle
    @Published var isShowingToast: Bool = false
    
    private let videoService: VideoServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(videoService: VideoServiceProtocol = VideoService()) {
        self.videoService = videoService
    }
    
    func uploadVideo(fileURL: URL) {
        toastState = .loading
        isShowingToast = true
        
        videoService.uploadVideo(fileURL)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completions in
                print(">>> postVideo -> receiveCompletion: \(completions)")
                switch completions {
                case .finished:
                    break
                case let .failure(error):
                    self?.setToast(state: .error)
                }
            }, receiveValue: { [weak self] _ in
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
