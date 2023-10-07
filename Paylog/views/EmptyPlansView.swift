//
//  EmptyPlansView.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 25..
//

import SwiftUI

struct EmptyPlansView: View {
    var body: some View {
        ContentUnavailableView(label: {
            Label("No Plans", systemImage: "list.bullet.rectangle.portrait.fill")
                .symbolRenderingMode(.hierarchical)
        }, description: {
            HStack(alignment: .lastTextBaseline) {
                Text("To add a new plan click on")
                Image(systemName: "plus.circle.fill")
                    .font(.headline)
                    .foregroundColor(.accentColor)
                    .symbolRenderingMode(.hierarchical)
                    .symbolEffect(.pulse.wholeSymbol)
            }
        })
    }
}

struct EmptyPlansView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyPlansView()
    }
}
