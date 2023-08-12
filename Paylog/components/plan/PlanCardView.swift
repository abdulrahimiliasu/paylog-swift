//
//  PlanCardView.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 22..
//

import SwiftUI

struct PlanCardView: View {
    @AppStorage("defaultCurrency") var defaultCurrency: String = SettingDefaults.currency
    @EnvironmentObject var planStore: PlanStore
    @State private var isOpen: Bool = false
    @Binding var plan: Plan

    func onDelete() {
        let index = planStore.plans.firstIndex { item in item.id == plan.id }
        planStore.deletePlan(index: index!)
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
                            self.onDelete()
                        }
                        NavigationLink {
                            EditPlanView(planToEdit: $plan)
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
                                FlowCardView(flow: $flow)
                            }
                        }
                    }
                    .frame(maxHeight: 500)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(AppColors.grey))
        )
        .contextMenu {
            Button(role: .destructive) { self.onDelete() } label: { Label("Delete", systemImage: "trash.circle.fill") }
        }
        .scaleEffect(isOpen ? 1.01 : 1)
    }
}

struct EditPlanView: View {
    @Binding var planToEdit: Plan
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    func didSavePlan() {
        notificationHaptics.notificationOccurred(.success)
        presentationMode.wrappedValue.dismiss()
    }

    var body: some View {
        PlanView(plan: $planToEdit)
            .navigationTitle("Edit Plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Save") {
                        didSavePlan()
                    }
                }
            }
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
    }
}
