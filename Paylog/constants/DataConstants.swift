//
//  DataConstants.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 23..
//

import Foundation

let currencies: [String: String] =
    [
        "USD": "$",
        "HUF": "ft",
        "CAD": "CAD",
        "NGN": "₦",
        "EUR": "€",
        "GBP": "£",
        "CHF": "CHF"
    ]

let currencyKeys = currencies.map(\.key)

let appIcons = (light: "Default", dark: "Dark")

enum SettingDefaults {
    public static let currency = "HUF"
    public static let appIcon = appIcons.light
}
