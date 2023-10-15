//
//  FlowTypePickerView.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 10. 14..
//

import SwiftUI

struct FlowTypePickerView: View {
    @Binding var flow: Flow

    var body: some View {
        Picker(selection: $flow.type, label: Text("Type")) {
            Text("Expense").tag(FlowType.expense)
            Text("Normal").tag(FlowType.normal)
            Text("Income").tag(FlowType.income)
        }
        .pickerStyle(.segmented)
    }
}

#Preview {
    FlowTypePickerView(flow: .constant(Flow(title: "Hello", price: 200, isChecked: false)))
}
