//
//  VideoService.swift
//  VideoGalleryApp
//
//  Created by Ichsan Indra Wahyudi on 29/09/24.
//

import Combine
import Foundation

protocol VideoServiceProtocol {
    func getVideos() -> AnyPublisher<VideoResponse, NetworkError>
    func uploadVideo(_ fileURL: URL) -> AnyPublisher<UploadedVideoResponse, NetworkError>
    func deleteVideo(_ id: String) -> AnyPublisher<DeletedVideoResponse, NetworkError>
}

class VideoService: VideoServiceProtocol {
    private let networkManager: NetworkManager<VideoTarget>
    
    init(networkManager: NetworkManager<VideoTarget> = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getVideos() -> AnyPublisher<VideoResponse, NetworkError> {
        networkManager.request(.getVideos, VideoResponse.self)
    }
    
    func uploadVideo(_ fileURL: URL) -> AnyPublisher<UploadedVideoResponse, NetworkError> {
        networkManager.request(.uploadVideo(fileURL: fileURL), UploadedVideoResponse.self)
    }
    
    func deleteVideo(_ id: String) -> AnyPublisher<DeletedVideoResponse, NetworkError> {
        networkManager.request(.deleteVideo(id: id), DeletedVideoResponse.self)
    }
}
