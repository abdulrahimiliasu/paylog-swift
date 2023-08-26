//
//  AlertKitUtils.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 08. 13..
//

import AlertKit
import Foundation

typealias AlertClosure = () async throws -> Void

@MainActor func withAlert(_ loading: String? = "Loading ...", action: @escaping AlertClosure) async {
    let loadingAlert = AlertKitAPI.showLoading(title: loading ?? "Loading")
    do {
        try await action()
        loadingAlert.dismiss()
    } catch {
        AlertKitAPI.present(title: "\(error.localizedDescription)", icon: .error, style: .iOS17AppleMusic, haptic: .error)
        loadingAlert.dismiss()
    }
}
