//
//  PlanStore.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 22..
//

import Combine
import Foundation

class PlanStore: ObservableObject {
    @Published var plans: [Plan] = .init()

    init() {
        // TODO: Remove this
        plans.append(
            Plan(title: "New Plan",
                 description: "Some Descriptions",
                 flows: [Flow(title: "Bus Ticket", price: 200, isChecked: false),
                         Flow(title: "Drinks", price: 1200, isChecked: false, type: .expense),
                         Flow(title: "Friends Payment", price: 2200, isChecked: false, type: .income)]))
    }

    func getTotalFlowAmountOf(plan: Plan) -> Int {
        return plan.flows.reduce(into: 0) { total, flow in
            if !flow.isChecked {
                let price = flow.type == .expense ? flow.price * -1 : flow.price
                total += price
            }
        }
    }

    func isPlansEmpty() -> Bool { return plans.isEmpty }

    func addPlan(plan: Plan) {
        plans.append(plan)
    }

    func updatePlan(plan: Plan) {}

    func deletePlan(index: Int) {
        plans.remove(at: index)
    }
}
