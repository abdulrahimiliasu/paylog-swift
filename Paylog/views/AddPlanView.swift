//
//  AddPlanView.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 08. 04..
//

import AlertKit
import SwiftUI

struct AddPlanView: View {
    @EnvironmentObject var planStore: PlanStore
    @EnvironmentObject var profileStore: ProfileStore
    @EnvironmentObject var repository: SupabaseRepository

    @Binding var isShowAddPlanView: Bool

    @State var planToAdd: Plan = .init(title: "", description: "", flows: [])

    func dismissModal() { self.isShowAddPlanView = false }

    func addNewPlan() async {
        await withAlert("Adding new plan") {
            guard let user = self.profileStore.user else { return }

            let plan = try await self.repository.addPlan(userId: user.id, plan: self.planToAdd)
            self.planStore.plans.append(plan)
            notificationHaptics.notificationOccurred(.success)
            return self.dismissModal()
        }
    }

    var body: some View {
        NavigationView {
            PlanView(plan: self.$planToAdd)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Add New Plan")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { self.dismissModal() }
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Button("Save") {
                            Task { await self.addNewPlan() }
                        }
                        .disabled(self.planToAdd.title.isEmpty)
                    }
                }
        }
    }
}

struct AddPlanView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlanView(isShowAddPlanView: .constant(true))
            .environmentObject(PlanStore())
            .environmentObject(ProfileStore())
            .environmentObject(SupabaseRepository.getInstance(supabaseClient))
    }
}
