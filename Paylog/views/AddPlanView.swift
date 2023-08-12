//
//  AddPlanView.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 08. 04..
//

import SwiftUI

struct AddPlanView: View {
    @EnvironmentObject var planStore: PlanStore

    @State var planToAdd: Plan = .init(title: "", description: "", flows: [])
    @Binding var isShowAddPlanView: Bool

    func dismissModal() { self.isShowAddPlanView = false }

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
                            guard self.planToAdd.title.isEmpty else {
                                self.planStore.addPlan(plan: self.planToAdd)
                                notificationHaptics.notificationOccurred(.success)
                                return self.dismissModal()
                            }
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
    }
}
