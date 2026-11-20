//
//  ProfilePictureUploadResponse.swift
//  SocialMediaUI
//
//  Created by ahmet karadağ on 20.11.2026.
//

import Foundation

struct ProfilePictureUploadResponse: Codable {
    let success: Bool
    let message: String
    let data: ProfilePictureData
}

struct ProfilePictureData: Codable{
    let profilePictureUrl: String
}
