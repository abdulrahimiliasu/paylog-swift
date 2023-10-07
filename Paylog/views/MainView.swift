//
//  MainView.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 22..
//

import AlertKit
import SwiftUI

struct MainView: View {
    @AppStorage("isUserOnboarded") private var isUserOnboarded: Bool = true
    @EnvironmentObject var planStore: PlanStore
    @EnvironmentObject var profileStore: ProfileStore
    @EnvironmentObject var supabaseRepository: SupabaseRepository

    @State private var isShowSettingsView = false
    @State private var isShowAddPlanView = false
    @State private var isLoadingPlans = false

    func refreshPlans() async { await self.fetchUserPlans() }

    func loadPlans() async {
        self.isLoadingPlans = true
        await self.profileStore.loadCurrentUser()
        await self.fetchUserPlans()
    }

    func fetchUserPlans() async {
        guard let user = profileStore.user else {
            self.isLoadingPlans = false
            return
        }

        do {
            let userPlans = try await supabaseRepository.getUserPlans(userId: user.id)
            self.planStore.plans = userPlans
            self.isLoadingPlans = false
        } catch {
            AlertKitAPI.showError(title: "Could not load user plans, \(error.localizedDescription)")
            self.isLoadingPlans = false
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                if self.isLoadingPlans {
                    ProgressView()
                } else {
                    if self.planStore.isPlansEmpty() {
                        EmptyPlansView()
                            .refreshable { await self.refreshPlans() }
                    } else {
                        ScrollView(.vertical) {
                            LazyVStack {
                                ForEach(self.$planStore.plans) { $plan in
                                    PlanCardView(plan: $plan)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .refreshable { await self.refreshPlans() }
            .sheet(isPresented: self.$isUserOnboarded) { OnBoardingView() }
            .sheet(isPresented: self.$isShowSettingsView) { SettingsView() }
            .sheet(isPresented: self.$isShowAddPlanView) { AddPlanView(isShowAddPlanView: self.$isShowAddPlanView) }
            .navigationTitle("Plans")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    HStack {
                        Button { 
                            self.isShowAddPlanView.toggle()
                            haptics.impactOccurred(intensity: 0.5)
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                        .disabled(self.profileStore.user == nil)
                        Button { self.isShowSettingsView.toggle() } label: {
                            Image(systemName: "gearshape.circle.fill")
                        }
                    }
                    .font(.title3)
                    .foregroundColor(.accentColor)
                    .symbolRenderingMode(.hierarchical)
                }
            }
            .onFirstAppear { Task { await self.loadPlans() } }
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
