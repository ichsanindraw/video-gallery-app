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
                print(">>> filename: \(filename)")
                
                print("Successfully loaded video data with size: \(videoData.count) bytes")
                
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

//enum VideoTarget {
//    case getVideos
//    case postVideo(fileURL: URL)
//    case deleteVideo(id: String)
//    
//    var path: String {
//        switch self {
//        case .getVideos:
//            return "resources/video"
//        case .postVideo:
//            return "video/upload"
//        case .deleteVideo:
//            return "resources/video/upload"
//        }
//    }
//    
//    var method: HTTPMethod {
//        switch self {
//        case .getVideos:
//            return .get
//            
//        case .postVideo:
//            return .post
//            
//        case .deleteVideo:
//            return .delete
//        }
//    }
//    
//    var queryParameters: [String: Any]? {
//        switch self {
//        case let .deleteVideo(id):
//            return [
//                "public_ids": id
//            ]
//            
//        default:
//            return [:]
//        }
//    }
//    
//    var uploadedData: Data? {
//        switch self {
//        case let .postVideo(fileURL):
//            let data = createBodyWithParameters(
//                fileURL: fileURL,
//                uploadPreset: "ml_default",
//                publicID: "publicID-\(UUID().uuidString)",
//                boundary: "Boundary-\(UUID().uuidString)"
//            )
//            
//            print(">>> body data: \(data)")
//            
//            return data
//            
//        default:
//            return nil
//        }
//    }
//    
//    private func createBodyWithParameters(
//        fileURL: URL,
//        uploadPreset: String,
//        publicID: String,
//        boundary: String
//    ) -> Data {
//        var body = Data()
//        
//        // Add upload_preset field
//        body.append("--\(boundary)\r\n".data(using: .utf8)!)
//        body.append("Content-Disposition: form-data; name=\"upload_preset\"\r\n\r\n".data(using: .utf8)!)
//        body.append("\(uploadPreset)\r\n".data(using: .utf8)!)
//        
//        // Add public_id field
//        body.append("--\(boundary)\r\n".data(using: .utf8)!)
//        body.append("Content-Disposition: form-data; name=\"public_id\"\r\n\r\n".data(using: .utf8)!)
//        body.append("\(publicID)\r\n".data(using: .utf8)!)
//        
//        // Add api_key field
//        body.append("--\(boundary)\r\n".data(using: .utf8)!)
//        body.append("Content-Disposition: form-data; name=\"api_key\"\r\n\r\n".data(using: .utf8)!)
//        body.append("\(Constants.API_KEY)\r\n".data(using: .utf8)!)
//        
//        // At this point, you can still convert the body to a string to verify the text part
//        if let uploadedData1 = String(data: body, encoding: .utf8) {
//            print(">>> body before file")
//        } else {
//            print(">>> body before file: Unable to convert body to string")
//        }
//        
//        
//        // Add file field
//        let filename = fileURL.lastPathComponent
//        let mimetype = "video/\(fileURL.pathExtension)"  // Define mime type for the file
//        let fileData = try! Data(contentsOf: fileURL)
//        
////        print(">>> filename: \(filename) | mimetype: \(mimetype) | fileData: \(fileData)")
//        
//        body.append("--\(boundary)\r\n".data(using: .utf8)!)
//        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
//        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)
//        
//        // After appending the file metadata, you can still convert the body to a string
//        if let uploadedData2 = String(data: body, encoding: .utf8) {
//            print(">>> body before file data -> 2")
//            // Print the size of the file data
//            print(">>> file size: \(fileData.count) bytes")
//
//            // Print the first few bytes of the file (if it's not too large)
//            print(">>> first few bytes of file data: \(fileData.prefix(20))")
//        } else {
//            print(">>> body before file data -> 2: Unable to convert body to string")
//        }
//        
//        print(">>> body size before appending fileData: \(body.count) bytes")
//        body.append(fileData)
//        print(">>> body size after appending fileData: \(body.count) bytes")
//        body.append("\r\n".data(using: .utf8)!)
//        
//        if let uploadedData3 = String(data: body, encoding: .utf8) {
//            print(">>> body before file data -> 3: \(uploadedData3)")
//        } else {
//            print(">>> body before file data -> 3: Unable to convert body to string")
//        }
//        
//        // Closing boundary
//        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
//        
//        if let uploadedData4 = String(data: body, encoding: .utf8) {
//            print(">>> body before file data -> 4: \(uploadedData4)")
//        } else {
//            print(">>> body before file data -> 4: Unable to convert body to string")
//        }
//        
//        return body
//    }
//}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}
