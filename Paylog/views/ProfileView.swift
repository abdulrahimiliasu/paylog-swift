//
//  ProfileView.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 23..
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var profile: ProfileStore
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var isEditMode: Bool = false
    @Binding var fullname: String
    @Binding var email: String

    func didSaveChanges() {
        if !isEditMode { return isEditMode.toggle() }
        profile.updateUserProfile(fullname: fullname, email: email)
        presentationMode.wrappedValue.dismiss()
    }

    var body: some View {
        Form {
            TextField("Fulname", text: $fullname)
                .disabled(!isEditMode)
                .font(.title3)
                .padding(.vertical)
                .foregroundColor(isEditMode ? .primary : .secondary)
            Text(email)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button { didSaveChanges() } label: {
                    Text(isEditMode ? "Done" : "Edit")
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(fullname: .constant("Abdulrahim"), email: .constant("abdulrahimiliasu@icloud.com"))
    }
}
