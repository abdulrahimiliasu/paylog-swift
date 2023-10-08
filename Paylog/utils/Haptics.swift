//
//  Haptics.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 10. 09..
//

import Foundation
import SwiftUI

class HapticsManager {
    public static let notification = UINotificationFeedbackGenerator()

    public static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }

    public static func success() {
        self.notification.notificationOccurred(.success)
    }

    public static func error() {
        self.notification.notificationOccurred(.error)
    }

    public static func warning() {
        self.notification.notificationOccurred(.warning)
    }
}
