//
//  PlanCardView.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 22..
//

import AlertKit
import SwiftUI

struct PlanCardView: View {
    @AppStorage("defaultCurrency") var defaultCurrency: String = SettingDefaults.currency
    @EnvironmentObject var planStore: PlanStore
    @EnvironmentObject var supabaseRepository: SupabaseRepository

    @Binding var plan: Plan
    @State private var isOpen: Bool = false
    @State private var isConfirmDeletion: Bool = false

    func onDelete() async {
        await withAlert("Deleting plan") {
            try await supabaseRepository.deletePlan(planId: plan.id)
            let index = planStore.plans.firstIndex { item in item.id == plan.id }
            planStore.deletePlan(index: index!)
            AlertKitAPI.showSuccess(title: "Plan deleted Successfully")
        }
    }

    func expandCard() { withAnimation(springAnimation) { 
        isOpen.toggle()
        haptics.impactOccurred(intensity: 0.5)
    }}

    var body: some View {
        VStack(spacing: 25) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(self.plan.title)
                        .bold()
                    if self.plan.description != "" {
                        Text(self.plan.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                Button { expandCard() } label: { Text("Details").font(.caption) }
            }
            .contentShape(Rectangle())
            .onTapGesture { expandCard() }

            if isOpen {
                let planCurrency = planStore.getPlanCurrency(plan)
                let totalFlowAmount = planStore.getTotalFlowAmountOf(plan: plan)
                VStack {
                    HStack(spacing: 0) {
                        Text("Total: \(planCurrency) \(totalFlowAmount)")
                            .contentTransition(.numericText(value: Double(totalFlowAmount)))
                            .bold()
                            .font(.callout)
                        Spacer()
                        RoundButton(image: "trash.circle.fill", font: .title, foregroundColor: .red, symbolRenderingMode: .monochrome) {
                            isConfirmDeletion.toggle()
                        }
                        NavigationLink {
                            EditPlanView(plan: plan)
                        } label: {
                            Label("Edit Plan", systemImage: "square.and.pencil.circle.fill")
                                .labelStyle(.iconOnly)
                                .symbolRenderingMode(.hierarchical)
                                .font(.title)
                        }
                    }
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach($plan.flows) { $flow in
                                FlowCardView(flow: $flow, plan: plan)
                            }
                        }
                    }
                    .frame(maxHeight: 500)
                }
                .alert("Delete plan", isPresented: $isConfirmDeletion, actions: {
                    Button("Cancel", role: .cancel) {}
                    Button("Delete", role: .destructive) { Task { await self.onDelete() }}
                }, message: { Text("Are you sure you want to continue ?") })
            }
        }
        .padding(20)
        .scaleEffect(isOpen ? 1.01 : 1)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.primary.opacity(0.2), lineWidth: isOpen ? 0 : 1)
                .fill(Color(AppColors.grey))
        )
    }
}

struct EditPlanView: View {
    let plan: Plan

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var supabaseRepository: SupabaseRepository
    @EnvironmentObject var profileStore: ProfileStore
    @EnvironmentObject var planStore: PlanStore
    @State private var planToEdit: Plan = .init(title: "", description: "", flows: [])

    func didSavePlan() async {
        await withAlert("Saving plan") {
            guard let user = profileStore.user else { return }
            try await supabaseRepository.updatePlan(userId: user.id, plan: planToEdit)
            try await supabaseRepository.updateFlows(planId: planToEdit.id, flows: planToEdit.flows)
            planStore.updatePlanTo(planToEdit)
        }
        notificationHaptics.notificationOccurred(.success)
        presentationMode.wrappedValue.dismiss()
    }

    var body: some View {
        PlanView(plan: $planToEdit)
            .navigationTitle("Edit plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Save") {
                        Task { await didSavePlan() }
                    }
                }
            }
            .onAppear { planToEdit = plan }
    }
}

struct PlanCardView_Previews: PreviewProvider {
    static var previews: some View {
        PlanCardView(
            plan:
            .constant(
                Plan(title: "Trip to Italy",
                     description: "This is going to be an awesome trip",
                     flows: [Flow(title: "Hello", price: 100, isChecked: false)])
            )
        )
        .environmentObject(PlanStore())
        .environmentObject(SupabaseRepository.getInstance(supabaseClient))
        .environmentObject(ProfileStore())
    }
}
