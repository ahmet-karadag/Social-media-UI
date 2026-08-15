//
//  CreatePostView.swift
//  SocialMediaUI
//
//  Created by ahmet karadağ on 15.08.2026.
//

import SwiftUI

struct CreatePostView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var postViewModel = PostViewModel()
    
    @State var title: String = ""
    @State var content: String = ""
    @State var isSubmitting: Bool = false
    
    var body: some View {
        NavigationStack{
            Form {
                Section(header: Text("Post details")) {
                    TextField("Title", text: $title)
                    
                    TextEditor(text: $content)
                        .frame(height: 150)
                }
            }
            .navigationTitle("New post")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("share"){
                        Task {
                            if let token = UserDefaults.standard.string(forKey: "authToken") {
                                isSubmitting = true
                                let success = await postViewModel.createPost(title: title, content: content, token: token)
                                isSubmitting = false
                                
                                if success {
                                    dismiss()
                                }
                            }
                        }
                    }
                    .disabled(title.isEmpty || content.isEmpty || isSubmitting)
                }
            }
        }
    }
}

#Preview {
    CreatePostView()
}
