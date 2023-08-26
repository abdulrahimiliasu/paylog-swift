//
//  AlertKitExtension.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 08. 13..
//

import AlertKit
import Foundation
import UIKit

public extension AlertKitAPI {
    static func showLoading(title: String, subtitle: String? = nil, icon: AlertIcon? = .spinnerSmall, style: AlertViewStyle? = .iOS17AppleMusic) -> AlertAppleMusic17View {
        let view = AlertAppleMusic17View(title: title, subtitle: subtitle, icon: icon)
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return view }
        view.present(on: window)
        return view
    }

    static func showError(title: String, subtitle: String? = nil) {
        self.present(title: title, subtitle: subtitle, icon: .error, style: .iOS17AppleMusic, haptic: .error)
    }

    static func showSuccess(title: String, subtitle: String? = nil) {
        self.present(title: title, subtitle: subtitle, icon: .done, style: .iOS17AppleMusic, haptic: .success)
    }
}
