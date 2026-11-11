//
//  PostDetailView.swift
//  SocialMediaUI
//
//  Created by ahmet karadağ on 25.10.2026.
//

import SwiftUI

struct PostDetailView: View {
    let post: Post
    var body: some View {
        
        ScrollView{
            VStack(alignment: .leading, spacing: 12){
                Text(post.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                if let author = post.author {
                    Text("Author: \(author.username)")
                        .font(.subheadline)
                        .foregroundStyle(Color.gray)
                }
                Divider()
                
                Text(post.content)
                    .font(Font.body.monospacedDigit())
            }
            padding()
        }
        .navigationTitle("post detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PostDetailView(
            post: Post(
            id: "1",
            title: "Örnek Başlık",
            content: "Bu bir örnek gönderi içeriğidir...",
            author: User(id: "u1", username: "Ahmet", email: "ahmet@test.com", createdAt: nil, updatedAt: nil),
            likesCount: 5,
            createdAt: "2026-01-01"
       )
      )
    }
}

