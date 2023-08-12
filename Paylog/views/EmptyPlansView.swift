//
//  EmptyPlansView.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 25..
//

import SwiftUI

struct EmptyPlansView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "list.bullet.rectangle.portrait.fill")
                .font(.largeTitle)
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.secondary)
            VStack {
                Text("Plans")
                    .font(.headline)
                HStack(alignment: .lastTextBaseline) {
                    Text("To add a new plan click on")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Image(systemName: "plus.circle.fill")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                        .symbolRenderingMode(.hierarchical)
                }
            }
        }
        .padding()
    }
}

struct EmptyPlansView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyPlansView()
    }
}
