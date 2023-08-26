//
//  UserProfile.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 22..
//

import Foundation

struct UserProfile: Codable {
    var userId: UUID
    var fullname: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case fullname = "full_name"
    }
}
