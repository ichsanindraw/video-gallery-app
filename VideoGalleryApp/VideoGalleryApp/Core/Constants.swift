//
//  Constants.swift
//  VideoGalleryApp
//
//  Created by Ichsan Indra Wahyudi on 29/09/24.
//

import Foundation

struct Constants {
    static let API_URL = Bundle.main.infoDictionary?["API_URL"] as? String ?? ""
    static let API_KEY = Bundle.main.infoDictionary?["API_KEY"] as? String ?? ""
    static let API_SECRET = Bundle.main.infoDictionary?["API_SECRET"] as? String ?? ""
    static let CLOUD_NAME = Bundle.main.infoDictionary?["CLOUD_NAME"] as? String ?? ""
}
