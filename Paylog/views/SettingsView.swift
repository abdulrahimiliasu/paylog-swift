//
//  SettingsView.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 23..
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("defaultCurrency") var defaultCurrency: String = SettingDefaults.currency
    @AppStorage("defaultAppIcon") var preferredAppIcon: AppIcon = SettingDefaults.appIcon

    @EnvironmentObject var settings: SettingsStore
    @EnvironmentObject var profile: ProfileStore

    func setAppIcon(to appIcon: AppIcon) {
        preferredAppIcon = appIcon
        settings.updateAppIcon(to: appIcon)
    }

    func setCurrency(to currency: String) { defaultCurrency = currency }

    var body: some View {
        NavigationView {
            Form {
                Section("Account") { GoToProfileView() }
                Section("Currency") {
                    Picker(selection: $defaultCurrency, label: Text("Default Currency")) {
                        ForEach(currencyKeys, id: \.self) { key in
                            Text(key).tag(key)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .onChange(of: defaultCurrency) {
                        setCurrency(to: defaultCurrency)
                    }
                }
                Section("App Settings") {
                    Picker(selection: $preferredAppIcon, label: Text("App Icon")) {
                        Text("White").tag(AppIcon.simple)
                        Text("Dark").tag(AppIcon.simpleDark)
                    }
                    .pickerStyle(.navigationLink)
                    .onChange(of: preferredAppIcon) {
                        setAppIcon(to: preferredAppIcon)
                    }
                    LabeledContent("App version", value: "1.0.0 (Beta)")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct GoToProfileView: View {
    @State private var isAuthenticateUser: Bool = false
    @EnvironmentObject var profile: ProfileStore

    var body: some View {
        if profile.user != nil, profile.userProfile != nil {
            NavigationLink {
                ProfileView()
            } label: {
                VStack(alignment: .leading, spacing: 5) {
                    Text(profile.userProfile!.fullname)
                        .bold()
                        .font(.title3)
                    Text(profile.user!.email!)
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding(5)
            }
        } else {
            Button { self.isAuthenticateUser = true } label: { Label("Sign in or create account", systemImage: "person.crop.circle") }
                .fullScreenCover(isPresented: $isAuthenticateUser) { LogInView(isPresented: $isAuthenticateUser) }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ProfileStore())
            .environmentObject(SettingsStore())
    }
}
