//
//  Video.swift
//  VideoGalleryApp
//
//  Created by Ichsan Indra Wahyudi on 29/09/24.
//

import Foundation

// MARK: GET

struct VideoResponse: Codable {
    let videos: [Video]
    let nextCursor: String?

    enum CodingKeys: String, CodingKey {
        case videos = "resources"
        case nextCursor = "next_cursor"
    }
}

struct Video: Codable, Identifiable {
    var id: String { publicID }
    
    let assetID: String
    let publicID: String
    let format: String
    let version: Int
    let resourceType: String
    let type: String
    let createdAt: String
    let bytes: Int
    let width: Int
    let height: Int
    let assetFolder: String
    let displayName: String
    let url: String
    let secureURL: String

    enum CodingKeys: String, CodingKey {
        case assetID = "asset_id"
        case publicID = "public_id"
        case format
        case version
        case resourceType = "resource_type"
        case type
        case createdAt = "created_at"
        case bytes
        case width
        case height
        case assetFolder = "asset_folder"
        case displayName = "display_name"
        case url
        case secureURL = "secure_url"
    }
}

// MARK: Deleted Video Response

struct DeletedVideoResponse: Codable {
    let deleted: [String: String]
    let deletedCounts: [String: DeletedVideoCount]
    let partial: Bool

    enum CodingKeys: String, CodingKey {
        case deleted
        case deletedCounts = "deleted_counts"
        case partial
    }
}

struct DeletedVideoCount: Codable {
    let original: Int
    let derived: Int
}

// MARK: Uploaded Video Response

struct UploadedVideoResponse: Codable {
    let assetID, publicID: String
    let version: Int
    let versionID, signature: String
    let width, height: Int
    let format, resourceType: String
    let createdAt: String
    let pages, bytes: Int
    let type, etag: String
    let placeholder: Bool
    let url: String
    let secureURL: String
    let playbackURL: String
    let assetFolder, displayName: String
    let existing: Bool
    let audio: AudioInfo
    let video: VideoInfo
    let frameRate, bitRate: Int
    let duration: Double
    let rotation: Int
    let originalFilename: String
    let nbFrames: Int

    enum CodingKeys: String, CodingKey {
        case assetID = "asset_id"
        case publicID = "public_id"
        case version
        case versionID = "version_id"
        case signature, width, height, format
        case resourceType = "resource_type"
        case createdAt = "created_at"
        case pages, bytes, type, etag, placeholder, url
        case secureURL = "secure_url"
        case playbackURL = "playback_url"
        case assetFolder = "asset_folder"
        case displayName = "display_name"
        case existing, audio, video
        case frameRate = "frame_rate"
        case bitRate = "bit_rate"
        case duration, rotation
        case originalFilename = "original_filename"
        case nbFrames = "nb_frames"
    }
}

struct AudioInfo: Codable {}

struct VideoInfo: Codable {
    let bitRate: String
    let codec: String
    let level: Int
    let pixFormat: String
    let profile: String
    let timeBase: String

    enum CodingKeys: String, CodingKey {
        case bitRate = "bit_rate"
        case codec
        case level
        case pixFormat = "pix_format"
        case profile
        case timeBase = "time_base"
    }
}
