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
    let assetFolder: String
    let assetId: String
    let audio: AudioInfo
    let bitRate: Int
    let bytes: Int
    let createdAt: String
    let displayName: String
    let duration: String
    let etag: String
    let existing: Int
    let format: String
    let frameRate: Int
    let height: Int
    let nbFrames: Int
    let originalFilename: String
    let pages: Int
    let placeholder: Int
    let playbackUrl: String
    let publicId: String
    let resourceType: String
    let rotation: Int
    let secureUrl: String
    let signature: String
    let tags: [String]
    let type: String
    let url: String
    let version: Int
    let versionId: String
    let video: VideoInfo
    let width: Int

    enum CodingKeys: String, CodingKey {
        case assetFolder = "asset_folder"
        case assetId = "asset_id"
        case audio
        case bitRate = "bit_rate"
        case bytes
        case createdAt = "created_at"
        case displayName = "display_name"
        case duration
        case etag
        case existing
        case format
        case frameRate = "frame_rate"
        case height
        case nbFrames = "nb_frames"
        case originalFilename = "original_filename"
        case pages
        case placeholder
        case playbackUrl = "playback_url"
        case publicId = "public_id"
        case resourceType = "resource_type"
        case rotation
        case secureUrl = "secure_url"
        case signature
        case tags
        case type
        case url
        case version
        case versionId = "version_id"
        case video
        case width
    }
}

struct AudioInfo: Codable {}

struct VideoInfo: Codable {
    let bitRate: Int
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
