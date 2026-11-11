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
}
