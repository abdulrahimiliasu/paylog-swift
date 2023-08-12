//
//  ProfileStore.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 23..
//

import Combine
import Foundation

class ProfileStore: ObservableObject {
    @Published var fullname: String = "Abdulrahim Iliasu"
    @Published var email: String = "abdulrahimiliasu@icloud.com"

    func updateUserProfile(fullname: String, email: String) {
        self.fullname = fullname
        self.email = email
    }
}
