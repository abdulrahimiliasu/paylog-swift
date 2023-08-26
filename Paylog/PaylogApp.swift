//
//  PaylogApp.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 21..
//

import SwiftUI

@main
struct PaylogApp: App {
    @StateObject private var planStore: PlanStore = .init()
    @StateObject private var profileStore: ProfileStore = .init()
    @StateObject private var settingsStore: SettingsStore = .init()
    @StateObject private var supabaseRepository: SupabaseRepository = .getInstance(supabaseClient)

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(planStore)
                .environmentObject(profileStore)
                .environmentObject(settingsStore)
                .environmentObject(supabaseRepository)
        }
    }
}
