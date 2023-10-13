//
//  FloatingButton.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 10. 13..
//

import SwiftUI

struct FloatingButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action, label: {
            Label("Button", systemImage: "plus")
                .padding()
                .labelStyle(.iconOnly)
                .font(.system(size: 35))
                .fontWeight(.light)
                .background(
                    Circle()
                        .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                        .fill(Color(AppColors.grey))
                )
        })
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0.0, y: 10)
    }
}

#Preview {
    FloatingButton {
        //
    }
}
