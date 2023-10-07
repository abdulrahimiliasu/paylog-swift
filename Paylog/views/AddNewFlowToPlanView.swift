//
//  AddNewFlowToPlanView.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 08. 04..
//

import SwiftUI

struct AddNewFlowToPlanView: View {
    @AppStorage("defaultCurrency") var defaultCurrency: String = SettingDefaults.currency
    @EnvironmentObject var planStore: PlanStore

    @Binding var plan: Plan
    @Binding var willAddNewFlow: Bool

    var focusedField: FocusState<PlanViewTextFields?>.Binding

    var body: some View {
        let currency = getCurrencySymbol(defaultCurrency)
        let totalAmount = withAnimation(springAnimation) {
            planStore.getTotalFlowAmountOf(plan: plan)
        }

        return HStack {
            Text("Total: \(currency) \(totalAmount)")
                .bold()
            Spacer()
            RoundButton(image: willAddNewFlow ? "chevron.down.circle.fill" : "plus.circle.fill") {
                self.focusedField.wrappedValue = .modalTitle
                withAnimation(springAnimation) { 
                    willAddNewFlow.toggle()
                    haptics.impactOccurred(intensity: 0.5)
                }
            }
        }
    }
}

struct AddNewFlowToPlanView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewFlowToPlanView(plan: .constant(previewDummyPlan), willAddNewFlow: .constant(false), focusedField: FocusState<PlanViewTextFields?>().projectedValue)
            .environmentObject(PlanStore())
    }
}
