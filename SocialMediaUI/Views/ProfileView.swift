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
    // 👇 İŞTE TAM BURAYA EKLİYORUZ (state'lerin yanına):
    @State private var selectedPhotoItem: PhotosPickerItem?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                
                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.callout)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                } else if let user = viewModel.user {
                    // 👇 İŞTE TAM BURAYA EKLİYORUZ (kullanıcı bilgileri gösterilirken):
                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                        ZStack {
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
                            
                            if viewModel.isUploading {
                                Circle()
                                    .fill(.black.opacity(0.45))
                                ProgressView()
                                    .tint(.white)
                            }
                        }
                        .frame(width: 110, height: 110)
                        .clipShape(Circle())
                    }
                    
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
            .onAppear {
                Task {
                    await viewModel.fetchProfile()
                }
            }
            // 👇 İŞTE TAM BURAYA EKLİYORUZ (.onAppear'dan sonra):
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
