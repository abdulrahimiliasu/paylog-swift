//
//  FlowCardView.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 22..
//

import AlertKit
import SwiftUI

struct FlowCardView: View {
    @Binding var flow: Flow
    let planId: UUID

    @AppStorage("defaultCurrency") var defaultCurrency: String = SettingDefaults.currency
    @EnvironmentObject var supabaseRepository: SupabaseRepository

    func didCheck() async {
        do {
            withAnimation(.linear(duration: 0.1)) { flow.isChecked.toggle() }
            try await supabaseRepository.updateFlow(planId: planId, flow: flow)
            haptics.impactOccurred()
        } catch { AlertKitAPI.showError(title: "Couldn't update status, a problem occured!") }
    }

    var body: some View {
        HStack {
            Image(systemName: flow.isChecked ? "checkmark.circle.fill" : "circle")
            HStack {
                Text(flow.title)
                Spacer()
                if flow.price != 0 {
                    Text("\(getPricePrefix(flow: flow, defaultCurrency: defaultCurrency)) \(flow.price)")
                        .foregroundColor(flow.isChecked ? .primary : getPriceForeGroundColor(flow))
                }
            }
            .strikethrough(flow.isChecked)
        }
        .contentShape(Rectangle())
        .onTapGesture { Task { await didCheck() }}
        .fontWeight(.light)
        .foregroundColor(flow.isChecked ? .gray : .primary)
    }
}

struct FlowCardView_Previews: PreviewProvider {
    static var previews: some View {
        FlowCardView(flow: .constant(Flow(title: "Bus Ticket", price: -3000, isChecked: true, tag: "")), planId: UUID())
            .environmentObject(SupabaseRepository.getInstance(supabaseClient))
    }
}
