//
//  OnBoardingView.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 21..
//

import SwiftUI

struct OnBoardingView: View {
    var body: some View {
        VStack {
            TopView()
            BottomView()
        }
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}

struct TopView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Image(AppImages.logo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120)
                Text("Plan all your\nfinances \nin one place")
                    .font(.custom("Inter-SemiBold", size: 34))
                    .fontWeight(.semibold)
                    .padding(.leading, 30)
                Text("Your personal finance calculator all in one place\nStreamline your finance.Your All-in-One solution for effortless expense and income planning!")
                    .font(.custom("Inter-SemiBold", size: 14))
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .padding(.leading, 30)
            }
            Spacer()
        }
    }
}

struct BottomView: View {
    @AppStorage("isUserOnboarded") private var isUserOnboarded: Bool = true

    var body: some View {
        VStack(spacing: 50) {
            Spacer()
            PrimaryButton(title: "Get Started") {
                isUserOnboarded = false
            }
            Spacer()
        }
        .padding(30)
    }
}
