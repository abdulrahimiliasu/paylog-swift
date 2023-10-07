//
//  PlanStore.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 22..
//

import Combine
import Foundation
import SwiftUI

@MainActor
class PlanStore: ObservableObject {
    @AppStorage("defaultCurrency") var defaultCurrency: String = SettingDefaults.currency
    @Published var plans: [Plan] = .init()
    
    let repository: SupabaseRepository
    init() { self.repository = SupabaseRepository.getInstance(supabaseClient) }

    func getTotalFlowAmountOf(plan: Plan) -> Int {
        return plan.flows.reduce(into: 0) { total, flow in
            if !flow.isChecked {
                let price = flow.type == .expense ? flow.price * -1 : flow.price
                total += price
            }
        }
    }

    func isPlansEmpty() -> Bool { return plans.isEmpty }

    func updatePlanTo(_ planToUpdate: Plan) {
        guard let index = plans.firstIndex(where: { $0.id == planToUpdate.id }) else { return }
        plans[index] = planToUpdate
    }

    func deletePlan(index: Int) {
        plans.remove(at: index)
    }

    func getPlanCurrency(_ plan: Plan) -> String {
        guard let currency = plan.currency else { return getCurrencySymbol(defaultCurrency) }
        return getCurrencySymbol(currency)
    }
}
