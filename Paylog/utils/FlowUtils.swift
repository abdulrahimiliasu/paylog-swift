//
//  FlowUtils.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 08. 05..
//

import SwiftUI

func getPriceForeGroundColor(_ flow: Flow) -> Color {
    switch flow.type {
    case .expense:
        return .red
    case .income:
        return .green
    case .normal:
        return .secondary
    }
}

func getPricePrefix(flow: Flow, defaultCurrency: String) -> String {
    let currency = currencies[defaultCurrency] ?? "$"
    switch flow.type {
    case .expense:
        return "- \(currency)"
    case .income:
        return "+ \(currency)"
    case .normal:
        return "\(currency)"
    }
}

func getNumberFormatter(defaultCurrency: String) -> NumberFormatter {
    let currency = currencies[defaultCurrency] ?? "$"
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = currency
        return formatter
    }()
    return numberFormatter
}
