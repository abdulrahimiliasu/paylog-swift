//
//  ViewConstants.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 23..
//

import Foundation
import SwiftUI

/// Screen and animations
let springAnimation: Animation = .spring(response: 0.4, dampingFraction: 0.7)
let screen = UIScreen.main.bounds

/// Haptics
let notificationHaptics = UINotificationFeedbackGenerator()
let haptics = UIImpactFeedbackGenerator(style: .medium)

/// Preview Content
let previewDummyFlow = Flow(title: "Bus Ticket", price: 1000, isChecked: false)
let previewDummyPlan = Plan(title: "Bus Ticket", description: "Buy bus ticket description", flows: [previewDummyFlow])
