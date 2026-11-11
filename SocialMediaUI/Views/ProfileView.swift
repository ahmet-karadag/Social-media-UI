//
//  ProfileView.swift
//  SocialMediaUI
//
//  Created by ahmet karadağ on 2.08.2026.
//

import SwiftUI

struct ProfileView: View {
    
    @Environment(AuthViewModel.self) private var authViewModel
    @State private var viewModel = ProfileViewModel()
    var body: some View {
        NavigationStack{
            VStack(spacing: 20){
                Spacer()
               
                if viewModel.isLoading {
                    ProgressView()
                }
                else if let errorMessage = viewModel.errorMessage{
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.callout)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                else if let user = viewModel.user{
                     Text(user.username)
                         .font(.title2)
                         .bold()
                    Text(user.email)
                        .foregroundStyle(.secondary)
                 }
                Button(role: .destructive) {
                    authViewModel.logout()
                } label: {
                    Text("Log out")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding()
                Spacer()
            }
            .navigationTitle("Profile")
            .onAppear(){
                Task {
                    await viewModel.fetchProfile()
                }
            }
            
        }
    }
}

#Preview {
    ProfileView()
        .environment(AuthViewModel())
}
