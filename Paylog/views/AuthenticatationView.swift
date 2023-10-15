//
//  AuthenticatationView.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 10. 07..
//

import SwiftUI

struct AuthenticatationView: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var settings: SettingsStore

    @Binding var isAuthenticated: Bool
    @State private var isAuthenticationError: Bool = false

    func onSuccess() { self.isAuthenticated = true }
    func onError() { self.isAuthenticationError = true }

    var body: some View {
        VStack(alignment: .center) {
            VStack(spacing: 20) {
                Spacer()
                Image(systemName: "lock.circle.fill")
                    .font(.system(size: 60))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(Color.accentColor)
                VStack {
                    Text("Paylog is Locked")
                        .font(.title)
                        .bold()
                    Text("Please authenticate to continue")
                        .font(.subheadline)
                }
                Spacer()
            }
            PrimaryButton(title: "Authenticate") {
                self.settings.authenticateDeviceOwner {
                    self.onSuccess()
                } onError: {
                    self.onError()
                }
            }
        }
        .alert(Text("Couldn't Autheneticate User!"),
               isPresented: self.$isAuthenticationError,
               actions: { Button(role: .cancel, action: {}, label: { Text("Dismiss") }) },
               message: { Text("An error occurred during authentication, please try again!") })
        .padding()
        .onChange(of: self.scenePhase) { _, newPhase in
            guard newPhase == .active && !self.isAuthenticationError else { return }
            self.settings.authenticateDeviceOwner(onSuccess: self.onSuccess, onError: self.onError)
        }
    }
}

#Preview {
    AuthenticatationView(isAuthenticated: .constant(true))
        .environmentObject(SettingsStore())
}
