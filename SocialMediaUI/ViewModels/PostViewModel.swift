//
//  PostViewModel.swift
//  SocialMediaUI
//
//  Created by ahmet karadağ on 30.07.2026.
//

import Foundation

@Observable
@MainActor

class PostViewModel {
    var posts: [Post] = []
    var pagination: Pagination?
    var errorMessage: String?
    var isloading: Bool = false
    
    
    func fetchPosts(token: String,page: Int = 1) async {
        isloading = true
        errorMessage = nil
        
        do {
            let response: PostListResponse = try await APIService.shared.request(
                endpoint: "/posts/all?page=\(page)&limit=10",
                method: "GET",
                token: token
                
            )
            
            self.posts = response.data
            self.pagination = response.pagination
            self.isloading = false
            
        }catch{
            self.errorMessage = error.localizedDescription
            self.isloading = false
        }
    }
    
    func createPost(title: String,content: String,token: String)async -> Bool{
        isloading = true
        errorMessage = nil
        
        let body = ["title": title,"content": content]
        
        do {
            let _: Post = try await APIService.shared.request(
                endpoint: "/posts/create",
                method: "POST",
                body: body,
                token: token
            )
            await fetchPosts(token: token)
            isloading = false
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            isloading = false
            return false
        }
    }
}

