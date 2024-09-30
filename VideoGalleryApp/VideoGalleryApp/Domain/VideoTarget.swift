//
//  VideoTarget.swift
//  VideoGalleryApp
//
//  Created by Ichsan Indra Wahyudi on 29/09/24.
//

import Foundation
import Moya

enum VideoTarget {
    case getVideos
    case uploadVideo(fileURL: URL)
    case deleteVideo(id: String)
}

extension VideoTarget: TargetType {
    var baseURL: URL {
        return URL(string: "\(Constants.API_URL)/\(Constants.CLOUD_NAME)")!
    }
    
    var path: String {
        switch self {
        case .getVideos:
            return "resources/video"
        case .uploadVideo:
            return "video/upload"
        case .deleteVideo:
            return "resources/video/upload"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getVideos:
            return .get
            
        case .uploadVideo:
            return .post
            
        case .deleteVideo:
            return .delete
        }
    }
    
    private var parameters: [String: Any] {
        switch self {
        case let .deleteVideo(id):
            return [
                "public_ids": id
            ]
            
        case .getVideos, .uploadVideo:
            return [:]
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .uploadVideo(fileURL):
            var formData: [MultipartFormData] = []
    
            if let videoData = fileURLToData(fileURL: fileURL) {
                let filename = fileURL.lastPathComponent
                
                // Append the video data
                //
                formData.append(
                    MultipartFormData(
                        provider: .data(videoData),
                        name: "file",
                        fileName: filename,
                        mimeType: "video/\(fileURL.pathExtension)"
                    )
                )
                
                // Append the `upload_preset`
                //
                formData.append(
                    MultipartFormData(
                        provider: .data("ml_default".data(using: .utf8)!),
                        name: "upload_preset",
                        mimeType: "text/plain"
                    )
                )
                
                // Append the `public_id`
                //
//                let publidIdValue =  "PublicID-\(UUID().uuidString)"
//                if let publidIdData = publidIdValue.data(using: .utf8) {
//                    formData.append(
//                        MultipartFormData(
//                            provider: .data(publidIdData),
//                            name: "public_id",
//                            mimeType: "text/plain"
//                        )
//                    )
//                }
                
                // Append the api key
                //
                if let apiKeyData = Constants.API_KEY.data(using: .utf8) {
                    formData.append(
                        MultipartFormData(
                            provider: .data(apiKeyData),
                            name: "api_key",
                            mimeType: "text/plain"
                        )
                    )
                }
            } else {
                print("Failed to load video data.")
            }
            
            return .uploadMultipart(formData)
            
        default:
            return .requestParameters(
                parameters: parameters, 
                encoding: method == .get ? URLEncoding.default : JSONEncoding.default
            )
        }
    }
    
    var headers: [String : String]? {
        [:]
    }
}

func fileURLToData(fileURL: URL) -> Data? {
    do {
        // Load data from the file URL
        let data = try Data(contentsOf: fileURL)
        return data
    } catch {
        // Handle the error (e.g., file not found, unreadable data)
        print("Error loading data from file: \(error.localizedDescription)")
        return nil
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}
