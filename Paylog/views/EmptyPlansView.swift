//
//  EmptyPlansView.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 25..
//

import SwiftUI

struct EmptyPlansView: View {
    @EnvironmentObject var profileStore: ProfileStore

    var body: some View {
        if self.profileStore.user == nil {
            NoUserView()
        } else {
            NoPlansView()
        }
    }
}

struct NoUserView: View {
    @State private var isLoginPresented = false

    var body: some View {
        ContentUnavailableView(label: {
            Label("No user found", systemImage: "person.crop.circle.badge.exclamationmark.fill")
                .symbolRenderingMode(.hierarchical)
        }, description: {
            Button("Login or create an account") { isLoginPresented = true }
                .fullScreenCover(isPresented: $isLoginPresented) {
                    LogInView(isPresented: $isLoginPresented)
                        .multilineTextAlignment(.leading)
                }
        })
    }
}

struct NoPlansView: View {
    var body: some View {
        ContentUnavailableView(label: {
            Label("No Plans", systemImage: "list.bullet.rectangle.portrait.fill")
                .symbolRenderingMode(.hierarchical)
        }, description: {
            HStack(alignment: .lastTextBaseline) {
                Text("To add a new plan click on")
                Image(systemName: "plus")
                    .foregroundColor(.accentColor)
                    .padding(5)
                    .background(
                        Circle()
                            .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                            .fill(Color(AppColors.grey))
                    )
                    .symbolEffect(.pulse.wholeSymbol)
            }
        })
    }
}

struct EmptyPlansView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyPlansView()
            .environmentObject(ProfileStore())
    }
}
