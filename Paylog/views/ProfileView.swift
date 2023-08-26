//
//  ProfileView.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 23..
//

import AlertKit
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var profile: ProfileStore
    @EnvironmentObject var supabaseRepository: SupabaseRepository
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var isEditMode: Bool = false
    @State private var fullname: String = ""
    @State private var email: String = ""

    func didSaveChanges() async {
        if !isEditMode { return isEditMode.toggle() }
        await withAlert("Updating profile") {
            guard let userId = profile.user?.id else { return }
            await profile.updateUserProfile(to: UserProfile(userId: userId, fullname: fullname))
            AlertKitAPI.showSuccess(title: "Success")
            presentationMode.wrappedValue.dismiss()
        }
    }

    func signOut() async {
        await withAlert("Signing out") {
            await supabaseRepository.signOutUser()
            profile.resetUser()
            presentationMode.wrappedValue.dismiss()
            AlertKitAPI.showSuccess(title: "Signed Out Successfully")
        }
    }

    func setFields() {
        if let userProfile = profile.userProfile, let user = profile.user {
            fullname = userProfile.fullname
            email = user.email!
        }
    }

    var body: some View {
        Form {
            Section {
                TextField("Fulname", text: $fullname)
                    .disabled(!isEditMode)
                    .font(.title3)
                    .padding(.vertical)
                    .foregroundColor(isEditMode ? .primary : .secondary)
                Text(email)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Button("Sign Out", role: .destructive) {
                Task { await signOut() }
            }
        }
        .onAppear { setFields() }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    Task { await didSaveChanges() }
                } label: {
                    Text(isEditMode ? "Done" : "Edit")
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(ProfileStore())
            .environmentObject(SupabaseRepository.getInstance(supabaseClient))
    }
}
