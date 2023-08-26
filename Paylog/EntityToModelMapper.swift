//
//  EntityToModelMapper.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 08. 19..
//

import Foundation

class EntityToModelMapper {
    public static func mapPlansToModel(_ plans: [PlanRow]) -> [Plan] {
        return plans.map { plan in
            let flows = mapFlowsToModel(plan.flows)
            return Plan(id: plan.id, title: plan.title, description: plan.description, currency: plan.currency, flows: flows)
        }
    }

    public static func mapFlowsToModel(_ flows: [FlowRow]) -> [Flow] {
        return flows.map { flow in
            Flow(id: flow.id, title: flow.title, price: flow.price, isChecked: flow.is_checked, type: FlowType(rawValue: flow.type) ?? .normal, tag: flow.tag)
        }
    }

    public static func mapPlanToInsertEntity(userId: UUID, plan: Plan) -> PlanRowInsert {
        return PlanRowInsert(id: plan.id, user_id: userId, title: plan.title, description: plan.description, currency: plan.currency)
    }

    public static func mapFlowsToEntity(planId: UUID, flows: [Flow]) -> [FlowRow] {
        return flows.map { flow in
            FlowRow(id: flow.id, plan_id: planId, title: flow.title, price: flow.price, is_checked: flow.isChecked, type: flow.type.rawValue, tag: flow.tag)
        }
    }
}
