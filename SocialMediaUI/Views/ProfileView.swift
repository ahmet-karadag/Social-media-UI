//
//  ProfileView.swift
//  SocialMediaUI
//
//  Created by ahmet karadağ on 2.08.2026.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @Environment(AuthViewModel.self) private var authViewModel
    @State private var viewModel = ProfileViewModel()
    @State private var selectedPhotoItem: PhotosPickerItem?
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack(alignment: .leading, spacing: 20) {
                    //Spacer()
                    if viewModel.isLoading {
                        ProgressView()
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .font(.callout)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    } else if let user = viewModel.user {
                        HStack(alignment: .center, spacing: 20){
                            
                            PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                                ZStack(alignment: .bottomTrailing) {
                                    Group{
                                        if let profilePicture = user.profilePicture,
                                           let url = URL(string: profilePicture) {
                                            AsyncImage(url: url) { phase in
                                                switch phase {
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                case .failure:
                                                    Image(systemName: "person.crop.circle.fill")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .foregroundStyle(.secondary)
                                                default:
                                                    ProgressView()
                                                }
                                            }
                                        } else {
                                            Image(systemName: "person.crop.circle.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    .frame(width: 96, height: 96)
                                    .clipShape(Circle())
                                    if viewModel.isUploading {
                                        Circle()
                                            .fill(.black.opacity(0.45))
                                        ProgressView()
                                            .tint(.white)
                                    }
                                }
                                .overlay {
                                    Circle()
                                        .stroke(Color(.separator), lineWidth: 1)
                                }
                                Image(systemName: "camera.fill")
                                    .font(.caption2.bold())
                                    .foregroundStyle(.white)
                                    .padding(7)
                                    .background(Color.accentColor)
                                    .clipShape(Circle())
                                    .overlay{
                                        Circle()
                                            .stroke(Color(.systemBackground),lineWidth: 2)
                                    }
                            }
                            HStack(spacing: 0){
                                statItem(count: "0", title: "Posts")
                                statItem(count: "0", title: "Followers")
                                statItem(count: "0", title: "Following")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading,spacing: 4){
                            Text(user.username)
                                .font(.title2)
                                .bold()
                            Text("no bio yet")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(user.email)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.top,2)
                        }
                        .padding(.horizontal)
                        
                    }
                    VStack(spacing: 8){
                        HStack(spacing: 8){
                            Button {
                                //will do next
                            } label: {
                                Text("edit profile")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.primary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(Color(.secondarySystemBackground))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            
                            Button {
                                //will do next
                            } label: {
                                Text("share profile")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.primary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(Color(.secondarySystemBackground))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            
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
                    }
                    
                    VStack(spacing: 0){
                        //tab indicator posts
                        HStack{
                            Image(systemName: "square.grid.3x3")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .overlay(alignment: .bottom){
                                    Rectangle()
                                        .frame(height: 1.5)
                                        .foregroundStyle(.primary)
                                }
                        }
                        .overlay(alignment: .top){
                            Divider()
                        }
                        VStack(spacing: 10){
                            Image(systemName: "camera")
                                .font(.system(size: 32))
                                .foregroundStyle(.secondary)
                            Text("No posts yet")
                                .font(.headline)
                            Text("Share photos and they will appear on your profile.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 48)
                    }
                    Spacer()
                }
            }
            .navigationTitle("Profile")
            .onAppear {
                Task {
                    await viewModel.fetchProfile()
                }
            }
            .onChange(of: selectedPhotoItem) { _, newItem in
                guard let newItem else { return }
                
                Task {
                    guard let rawData = try? await newItem.loadTransferable(type: Data.self),
                          let uiImage = UIImage(data: rawData),
                          let jpegData = uiImage.jpegData(compressionQuality: 0.8) else {
                        return
                    }
                    
                    await viewModel.uploadProfilePicture(imageData: jpegData)
                }
            }
        }
    }
}

private func statItem(count: String, title: String) -> some View {
    VStack(spacing: 2) {
        Text(count)
            .font(.headline.bold())
        Text(title)
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    .frame(maxWidth: .infinity)
}
