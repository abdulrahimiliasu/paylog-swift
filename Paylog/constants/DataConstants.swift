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
        "EUR": "€",
        "JPY": "¥",
        "GBP": "£",
        "AUD": "$",
        "CAD": "$",
        "CHF": "CHF",
        "CNY": "¥",
        "SEK": "kr",
        "NZD": "$",
        "KRW": "₩",
        "SGD": "$",
        "HKD": "HK$",
        "NOK": "kr",
        "MXN": "$",
        "INR": "₹",
        "BRL": "R$",
        "RUB": "₽",
        "ZAR": "R",
        "TRY": "₺",
        "BGN": "лв",
        "CZK": "Kč",
        "DKK": "kr",
        "IDR": "Rp",
        "ILS": "₪",
        "NGN": "₦",
        "HUF": "ft",
        "MYR": "RM",
        "RON": "lei",
        "PHP": "₱",
        "PLN": "zł",
        "THB": "฿",
        "ISK": "kr",
        "HRK": "kn",
        "AED": "د.إ",
        "COP": "Col$",
        "SAR": "﷼",
        "BHD": ".د.ب",
        "KWD": "KD",
        "CLP": "$",
        "ARS": "$",
        "EGP": "£",
        "TWD": "NT$",
        "IQD": "ع.د",
        "NPR": "रू",
        "VND": "₫",
        "PKR": "₨",
        "UZS": "so'm",
        "DZD": "د.ج",
        "KHR": "៛",
        "KZT": "₸",
        "LKR": "රු",
        "BDT": "৳",
        "GTQ": "Q",
        "XOF": "CFA",
        "JMD": "J$",
        "LBP": "ل.ل",
        "PYG": "₲",
        "AFN": "Af",
        "TTD": "TT$",
        "TZS": "TSh",
        "GHS": "₵",
        "AOA": "Kz",
        "UYU": "$U",
        "BAM": "KM",
        "TOP": "T$",
        "PGK": "K",
        "SDG": "ج.س.",
        "NIO": "C$",
        "BWP": "P",
        "NAD": "$",
        "BTN": "Nu.",
        "PEN": "S/",
        "MOP": "MOP$",
        "RSD": "din.",
        "MUR": "₨",
        "SYP": "ل.س",
        "AON": "Kz",
    ]

let currencyKeys = Locale.Currency.isoCurrencies.map(\.identifier)

enum SettingDefaults {
    public static let currency = Locale.current.currency?.identifier ?? "USD"
    public static let appIcon: AppIcon = .primary
}
