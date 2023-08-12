//
//  RoundButton.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 22..
//

import SwiftUI

struct RoundButton: View {
    var image: String
    var font: Font = .title2
    var foregroundColor: Color = .accentColor
    var symbolRenderingMode: SymbolRenderingMode = .hierarchical
    var title: String = "Button"
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(self.title, systemImage: image)
                .labelStyle(.iconOnly)
                .symbolRenderingMode(symbolRenderingMode)
                .foregroundStyle(foregroundColor)
                .font(font)
        }
    }
}

struct RoundButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundButton(image: "plus.circle.fill") {}
    }
}
