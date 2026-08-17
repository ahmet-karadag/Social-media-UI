//
//  HomeView.swift
//  SocialMediaUI
//
//  Created by ahmet karadağ on 17.08.2026.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack{
            PostListView()
                .navigationTitle("Main Page")
        }
        
    }
}

#Preview {
    HomeView()
        .environment(AuthViewModel())
}
