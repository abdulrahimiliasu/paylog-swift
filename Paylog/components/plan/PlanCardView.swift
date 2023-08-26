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

    @State private var isOpen: Bool = false
    @Binding var plan: Plan

    func onDelete() async {
        await withAlert("Deleting plan") {
            try await supabaseRepository.deletePlan(planId: plan.id)
            let index = planStore.plans.firstIndex { item in item.id == plan.id }
            planStore.deletePlan(index: index!)
            AlertKitAPI.showSuccess(title: "Plan deleted Successfully")
        }
    }

    func expandCard() { withAnimation(springAnimation) { isOpen.toggle() }}

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
                RoundButton(image: "chevron.up") { expandCard() }
                    .rotationEffect(isOpen ? .zero : .degrees(180))
            }
            .contentShape(Rectangle())
            .onTapGesture { expandCard() }

            if isOpen {
                VStack {
                    HStack {
                        Text("Total: \(currencies[defaultCurrency] ?? "$") \(planStore.getTotalFlowAmountOf(plan: plan))")
                            .bold()
                            .font(.callout)
                        Spacer()
                        RoundButton(image: "trash.circle.fill", font: .title, foregroundColor: .red, symbolRenderingMode: .monochrome) {
                            Task { await self.onDelete() }
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
                                FlowCardView(flow: $flow, planId: plan.id)
                            }
                        }
                    }
                    .frame(maxHeight: 500)
                }
            }
        }
        .padding(20)
        .scaleEffect(isOpen ? 1.01 : 1)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(AppColors.grey))
        )
        .contextMenu {
            Button(role: .destructive) {
                Task { await self.onDelete() }
            } label: { Label("Delete", systemImage: "trash") }
        }
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
