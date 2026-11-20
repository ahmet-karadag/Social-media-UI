//
//  ProfileViewModel.swift
//  SocialMediaUI
//
//  Created by ahmet karadağ on 11.11.2026.
//

import Foundation

@Observable
@MainActor

class ProfileViewModel {
    var user: User?
    var errorMessage: String?
    var isLoading: Bool = false
    
    var isUploading: Bool = false
    
    private let tokenKey = "authToken"
    
    func fetchProfile() async {
        guard !isLoading else { return }
        guard let token = KeyChainManager.shared.get(key: tokenKey) else {
            self.errorMessage = "Session token not found."
         return
      }
        isLoading = true
        errorMessage = nil
        
        defer {isLoading = false}
        
        do{
            let response: UserProfile = try await APIService.shared.request(
                endpoint: "/user/me",
                method: "GET",
                token: token
            )
            self.user = response.user
        }catch{
            self.errorMessage = error.localizedDescription
        }
    }
    func uploadProfilePicture(imageData: Data) async {
            guard !isUploading else { return }
            guard let token = KeyChainManager.shared.get(key: tokenKey) else {
                self.errorMessage = "Session token not found."
                return
            }
            
            isUploading = true
            self.errorMessage = nil
            
            defer { isUploading = false }
            
            do {
                let response: ProfilePictureUploadResponse = try await APIService.shared.uploadMultipart(
                    endpoint: "/user/profile-picture",
                    token: token,
                    imageData: imageData
                )
                self.user?.profilePicture = response.data.profilePictureUrl
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
}
