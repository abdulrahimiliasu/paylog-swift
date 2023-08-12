//
//  MainView.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 22..
//

import SwiftUI

struct MainView: View {
    @AppStorage("isUserOnboarded") private var isUserOnboarded: Bool = true
    @EnvironmentObject var planStore: PlanStore

    @State private var isShowSettingsView = false
    @State private var isShowAddPlanView = false

    func refreshPlans() {} /// Refresh plans data

    var body: some View {
        NavigationView {
            VStack {
                if self.planStore.isPlansEmpty() { EmptyPlansView() } else {
                    ScrollView(.vertical) {
                        LazyVStack {
                            ForEach(self.$planStore.plans) { $plan in
                                PlanCardView(plan: $plan)
                            }
                        }
                    }
                }
            }
            .refreshable { self.refreshPlans() }
            .padding(.horizontal)
            .sheet(isPresented: self.$isUserOnboarded) { OnBoardingView() }
            .sheet(isPresented: self.$isShowSettingsView) { SettingsView() }
            .sheet(isPresented: self.$isShowAddPlanView) { AddPlanView(isShowAddPlanView: self.$isShowAddPlanView) }
            .navigationTitle("Plans")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    RoundButton(image: "plus.circle.fill") { self.isShowAddPlanView.toggle() }
                    RoundButton(image: "gearshape.circle.fill") { self.isShowSettingsView.toggle() }
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(PlanStore())
            .environmentObject(ProfileStore())
            .environmentObject(SettingsStore())
    }
}
