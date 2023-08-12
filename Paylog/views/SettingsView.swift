//
//  SettingsView.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 23..
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("defaultCurrency") var defaultCurrency: String = SettingDefaults.currency
    @AppStorage("defaultAppIcon") var preferredAppIcon: String = SettingDefaults.appIcon
    @EnvironmentObject var settings: SettingsStore
    @EnvironmentObject var profile: ProfileStore

    func setAppIcon(to appIcon: String) {
        preferredAppIcon = appIcon
        let selectedIcon: AppIcon = appIcon == appIcons.light ? .primary : .dark
        settings.updateAppIcon(to: selectedIcon)
    }

    func setCurrency(to currency: String) { defaultCurrency = currency }

    var body: some View {
        NavigationView {
            Form {
                Section("Account") {
                    NavigationLink {
                        ProfileView(fullname: $profile.fullname, email: $profile.email)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(profile.fullname)
                                .bold()
                                .font(.title3)
                            Text(profile.email)
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                        .padding(5)
                    }
                }
                Section("Currency") {
                    Picker(selection: $defaultCurrency, label: Text("Default Currency")) {
                        ForEach(currencyKeys, id: \.self) { key in
                            Text(key).tag(key)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .onChange(of: defaultCurrency, perform: { newCurrency in
                        setCurrency(to: newCurrency)
                    })
                }
                Section("App Icon") {
                    Picker(selection: $preferredAppIcon, label: Text("Icon")) {
                        Text(appIcons.light).tag(appIcons.light)
                        Text(appIcons.dark).tag(appIcons.dark)
                    }
                    .pickerStyle(.navigationLink)
                    .onChange(of: preferredAppIcon, perform: { selectedAppIcon in
                        setAppIcon(to: selectedAppIcon)
                    })
                }
                LabeledContent("App version", value: "1.0.0 (Beta)")
            }
            .navigationTitle("Settings")
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
