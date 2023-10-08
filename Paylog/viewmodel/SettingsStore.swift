//
//  SettingsStore.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 23..
//

import Combine
import Foundation
import LocalAuthentication
import UIKit

enum AppIcon: String, CaseIterable, Identifiable {
    var id: String { return rawValue }
    case primary = "AppIcon"
    case dark = "AppIconDark"
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

    func authenticateDeviceOwner(onSuccess: @escaping () -> Void, onError: @escaping () -> Void) {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else { return onError() }
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Paylog needs to authenticate user to continue") { success, _ in
            guard success else { return onError() }
            return onSuccess()
        }
    }
}
