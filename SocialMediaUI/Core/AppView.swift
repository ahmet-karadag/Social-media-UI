//
//  AppView.swift
//  SocialMediaUI
//
//  Created by ahmet karadağ on 17.08.2026.
//

import SwiftUI

struct AppView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    var body: some View {
        Group{
            if authViewModel.isAuthenticated {
                MainTabBarView()
            }else{
                LoginView()
            }
        }
    }
}

#Preview {
    AppView()
}
