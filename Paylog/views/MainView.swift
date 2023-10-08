//
//  MainView.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 22..
//

import AlertKit
import SwiftUI

struct MainView: View {
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("isAuthenticationEnabled") private var isAuthenticationEnabled: Bool = false
    @State private var isAuthenticated: Bool = false

    var body: some View {
        VStack {
            if isAuthenticationEnabled && !isAuthenticated {
                AuthenticatationView(isAuthenticated: $isAuthenticated)
            } else {
                HomeView()
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            guard newPhase == .background else { return }
            self.isAuthenticated = false
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(PlanStore())
            .environmentObject(ProfileStore())
            .environmentObject(SettingsStore())
            .environmentObject(SupabaseRepository.getInstance(supabaseClient))
    }
}
