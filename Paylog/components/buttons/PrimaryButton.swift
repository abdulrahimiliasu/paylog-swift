//
//  PrimaryButton.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 28..
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action, label: {
            Text(title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: 400, alignment: .center)
                .padding()
        })
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color.accentColor)
        )
        .shadow(color: .accentColor.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(title: "Get Started") {
            print("Hello")
        }
    }
}
