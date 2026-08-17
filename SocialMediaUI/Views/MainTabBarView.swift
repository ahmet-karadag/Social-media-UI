//
//  MainTabBarView.swift
//  SocialMediaUI
//
//  Created by ahmet karadağ on 17.08.2026.
//

import SwiftUI

struct MainTabBarView: View {
    @State private var selectTab: Int = 0
    
    var body: some View {
        
        TabView(selection: $selectTab) {
            Tab("MainPage", systemImage: "house", value: 0) {
                HomeView()
            }
            Tab("Search", systemImage: "magnifyingglass", value: 1){
                NavigationStack{
                    Text("Search")
                        .navigationTitle("Search")
                }
            }
            Tab("create", systemImage: "plus.square", value: 2){
                NavigationStack{
                    CreatePostView()
                }
            }
            Tab("Profile", systemImage: "person", value: 3){
                NavigationStack{
                    ProfileView()
                }
            }
        }
        .tint(.primary)
        
    }
}

#Preview {
    MainTabBarView()
        .environment(AuthViewModel())
}
