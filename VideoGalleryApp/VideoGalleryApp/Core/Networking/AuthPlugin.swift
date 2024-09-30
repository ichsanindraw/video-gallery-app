//
//  AuthPlugin.swift
//  VideoGalleryApp
//
//  Created by Ichsan Indra Wahyudi on 30/09/24.
//


import Foundation
import Moya

public final class AuthPlugin: PluginType {
    public init() {}
    
    private var request: (RequestType, TargetType)?
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        
        let credentials = "\(Constants.API_KEY):\(Constants.API_SECRET)"
        if let credentialsData = credentials.data(using: .utf8) {
            request.setValue("Basic \(credentialsData.base64EncodedString())", forHTTPHeaderField: "Authorization")
        }

        return request
    }
}

