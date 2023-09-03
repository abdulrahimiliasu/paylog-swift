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

func getCurrencySymbol(_ currency: String) -> String {
    return currencies[currency] ?? currency
}

func getPricePrefix(flow: Flow, defaultCurrency: String) -> String {
    let currency = getCurrencySymbol(defaultCurrency)
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
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = getCurrencySymbol(defaultCurrency)
        return formatter
    }()
    return numberFormatter
}
