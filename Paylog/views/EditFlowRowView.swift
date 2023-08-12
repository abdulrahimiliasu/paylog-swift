//
//  FlowView.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 24..
//

import SwiftUI

struct EditFlowRowView: View {
    @AppStorage("defaultCurrency") var defaultCurrency: String = SettingDefaults.currency
    @EnvironmentObject var planStore: PlanStore

    @Binding var flowToEdit: Flow
    @State private var isEditMode: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("\(flowToEdit.title)")
            Text("\(getPricePrefix(flow: flowToEdit, defaultCurrency: defaultCurrency)) \(flowToEdit.price)")
                .keyboardType(.numberPad)
                .foregroundColor(getPriceForeGroundColor(flowToEdit))
                .font(.subheadline)
        }
        .onTapGesture { isEditMode.toggle() }
        .strikethrough(flowToEdit.isChecked)
        .foregroundColor(flowToEdit.isChecked ? .gray : .primary)
        .contentShape(Rectangle())
        .swipeActions(edge: .leading) {
            Button {
                flowToEdit.isChecked.toggle()
            } label: {
                Image(systemName: "checkmark.circle.fill")
            }
            .tint(.accentColor)
        }
    }
}

struct FlowView_Previews: PreviewProvider {
    static var previews: some View {
        EditFlowRowView(flowToEdit: .constant(Flow(title: "Expense", price: 1000, isChecked: false)))
            .environmentObject(PlanStore())
    }
}
