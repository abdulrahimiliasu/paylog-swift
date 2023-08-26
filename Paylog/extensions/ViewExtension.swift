//
//  AddEditFlowAlert.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 29..
//

import SwiftUI
import UIKit

extension View {
    func onFirstAppear(_ action: @escaping () -> Void) -> some View {
        modifier(FirstAppear(action: action))
    }
}

struct FirstAppear: ViewModifier {
    @State private var hasAppeared: Bool = false
    let action: () -> Void

    func body(content: Content) -> some View {
        content.onAppear {
            guard !hasAppeared else { return }
            hasAppeared = true
            action()
        }
    }
}
