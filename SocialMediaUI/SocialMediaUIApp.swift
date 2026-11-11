//
//  SocialMediaUIApp.swift
//  SocialMediaUI
//
//  Created by ahmet karadağ on 23.07.2026.
//

import SwiftUI

@main
struct SocialMediaUIApp: App {
    @State private var authViewModel = AuthViewModel()
    @State private var postViewModel = PostViewModel()
    var body: some Scene {
        WindowGroup {
           AppView()
        }
        .environment(authViewModel)
        .environment(postViewModel)
        
    }
}
