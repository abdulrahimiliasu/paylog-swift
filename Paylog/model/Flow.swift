//
//  Flow.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 22..
//

import Foundation

enum FlowType: String, Codable {
    case income = "Income"
    case normal = "Normal"
    case expense = "Expense"
}

struct Flow: Identifiable, Codable {
    var id = UUID()
    var title: String
    var price: Int
    var isChecked: Bool
    var type: FlowType = .normal
    var tag: String?
}
