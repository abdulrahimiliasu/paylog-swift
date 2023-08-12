//
//  Plan.swift
//  Paylog
//
//  Created by Abdulrahim Illo on 2023. 07. 22..
//

import Foundation

struct Plan: Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var flows: [Flow]
}
