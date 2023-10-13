//
//  LogInView.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 08. 12..
//

import AlertKit
import SwiftUI

enum LogInViewTextFields {
    case email, password
}

struct LogInView: View {
    @FocusState private var currentTextFieldFocus: LogInViewTextFields?
    @EnvironmentObject var profileStore: ProfileStore
    @EnvironmentObject var planStore: PlanStore
    @EnvironmentObject var supabaseRepository: SupabaseRepository

    @Binding var isPresented: Bool
    @State private var email: String = ""
    @State private var password: String = ""

    func logInUser() async {
        await withAlert("Signing in") {
            currentTextFieldFocus = nil
            let user = try await supabaseRepository.signInUser(email: email, password: password)
            await profileStore.setUser(to: user)
            isPresented.toggle()
            do {
                let userPlans = try await supabaseRepository.getUserPlans(userId: user.id)
                self.planStore.plans = userPlans
            } catch {
                AlertKitAPI.showError(title: "Could not load user plans, \(error.localizedDescription)")
            }

            AlertKitAPI.present(title: "Sign In Successfull", icon: .done, style: .iOS17AppleMusic, haptic: .success)
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 50) {
                    TopDescriptionView(
                        heading: "Login",
                        subHeading: "Your personal finance calculator all in one place\nLogin to access your account")
                    VStack(spacing: 20) {
                        TextField("Email", text: $email)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.gray.opacity(0.1)))
                            .keyboardType(.emailAddress)
                            .focused($currentTextFieldFocus, equals: .email)
                            .onSubmit { currentTextFieldFocus = .password }
                        SecureField("Password", text: $password)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.gray.opacity(0.1)))
                            .focused($currentTextFieldFocus, equals: .password)
                            .onSubmit { currentTextFieldFocus = nil }
                        NavigationLink("Create an account") {
                            SignUpView(isPresented: $isPresented)
                        }
                        PrimaryButton(title: "Continue") {
                            Task { await logInUser() }
                        }
                        .disabled(email == "" || password == "")
                        Spacer()
                    }
                    .padding()
                }
                .textInputAutocapitalization(.never)
                .onAppear { currentTextFieldFocus = .email }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) { RoundButton(image: "xmark.circle.fill") { isPresented.toggle() } }
                }
            }
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView(isPresented: .constant(false))
            .environmentObject(ProfileStore())
            .environmentObject(SupabaseRepository.getInstance(supabaseClient))
    }
}
