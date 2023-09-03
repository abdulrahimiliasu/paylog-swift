//
//  SettingsStore.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 23..
//

import Combine
import Foundation
import UIKit

enum AppIcon: String, CaseIterable, Identifiable {
    var id: String { return rawValue }
    case primary = "AppIcon"
    case dark = "AppIconDark"
    case simple = "AppIconSimple"
    case simpleDark = "AppIconSimpleDark"
}

class SettingsStore: ObservableObject {
    @Published private(set) var appIcon: AppIcon

    init() {
        guard let currentIcon = UIApplication.shared.alternateIconName else {
            self.appIcon = .primary
            return
        }
        self.appIcon = AppIcon(rawValue: currentIcon) ?? .primary
    }

    func updateAppIcon(to icon: AppIcon) {
        self.appIcon = icon
        Task { @MainActor in
            guard UIApplication.shared.alternateIconName != icon.rawValue else { return }

            do {
                try await UIApplication.shared.setAlternateIconName(icon == .primary ? nil : icon.rawValue)
            } catch {
                self.appIcon = .primary
            }
        }
    }
}
