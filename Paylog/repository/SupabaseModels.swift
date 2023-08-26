//
//  SupabaseModels.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 08. 12..
//

import Foundation

struct PlanRow: Codable {
    var id: UUID
    var user_id: UUID
    var title: String
    var description: String
    var currency: String? = nil
    var flows: [FlowRow]
}

struct PlanRowInsert: Codable {
    var id: UUID
    var user_id: UUID
    var title: String
    var description: String
    var currency: String? = nil
}

struct FlowRow: Codable {
    var id: UUID
    var plan_id: UUID
    var title: String
    var price: Int
    var is_checked: Bool
    var type: String
    var tag: String? = nil
}
