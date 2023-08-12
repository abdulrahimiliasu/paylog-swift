//
//  FlowCardView.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 22..
//

import SwiftUI

struct FlowCardView: View {
    @AppStorage("defaultCurrency") var defaultCurrency: String = SettingDefaults.currency
    @Binding var flow: Flow

    func didCheck() {
        withAnimation(.linear(duration: 0.2)) {
            flow.isChecked.toggle()
        }
        haptics.impactOccurred()
    }

    var body: some View {
        HStack {
            Image(systemName: flow.isChecked ? "checkmark.circle.fill" : "circle")
            HStack {
                Text(flow.title)
                Spacer()
                Text("\(getPricePrefix(flow: flow, defaultCurrency: defaultCurrency)) \(flow.price)")
                    .foregroundColor(flow.isChecked ? .primary : getPriceForeGroundColor(flow))
            }
            .strikethrough(flow.isChecked)
        }
        .contentShape(Rectangle())
        .onTapGesture { didCheck() }
        .fontWeight(.light)
        .foregroundColor(flow.isChecked ? .gray : .primary)
    }
}

struct FlowCardView_Previews: PreviewProvider {
    static var previews: some View {
        FlowCardView(flow: .constant(Flow(title: "Bus Ticket", price: -3000, isChecked: true, tag: "")))
    }
}
