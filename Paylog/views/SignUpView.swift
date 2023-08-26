//
//  SignUpView.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 08. 12..
//

import AlertKit
import SwiftUI

enum SignUpTextFields {
    case fullname, email, password
}

struct SignUpView: View {
    @Binding var isPresented: Bool

    @State private var fullname: String = ""
    @State private var email: String = ""
    @State private var password: String = ""

    @FocusState private var currentTextFieldFocus: SignUpTextFields?
    @EnvironmentObject var supabaseRepository: SupabaseRepository
    @EnvironmentObject var profileStore: ProfileStore

    func signUpUser() async {
        currentTextFieldFocus = nil
        await withAlert("Creating account") {
            let user = try await supabaseRepository.createNewAccount(email: email, password: password, fullname: fullname)
            await profileStore.setUser(to: user)
            isPresented.toggle()
            AlertKitAPI.present(title: "Account created successfully", icon: .done, style: .iOS17AppleMusic, haptic: .success)
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 50) {
                    TopDescriptionView(
                        heading: "Create an account",
                        subHeading: "Your personal finance calculator all in one place\nJoin today to start your journey.")
                    VStack(spacing: 20) {
                        TextField("Fullname", text: $fullname)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.gray.opacity(0.1)))
                            .focused($currentTextFieldFocus, equals: .fullname)
                            .onSubmit { currentTextFieldFocus = .email }
                        TextField("Email", text: $email)
                            .padding()
                            .keyboardType(.emailAddress)
                            .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.gray.opacity(0.1)))
                            .focused($currentTextFieldFocus, equals: .email)
                            .onSubmit { currentTextFieldFocus = .password }
                        SecureField("Password", text: $password)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.gray.opacity(0.1)))
                            .focused($currentTextFieldFocus, equals: .password)
                            .onSubmit { currentTextFieldFocus = nil }
                        PrimaryButton(title: "Sign up") {
                            Task { await signUpUser() }
                        }
                        .disabled(email == "" || password == "" || fullname == "")
                        Spacer()
                    }
                    .padding()
                }
                .onAppear { currentTextFieldFocus = .fullname }
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(isPresented: .constant(true))
            .environmentObject(ProfileStore())
            .environmentObject(SupabaseRepository.getInstance(supabaseClient))
    }
}
