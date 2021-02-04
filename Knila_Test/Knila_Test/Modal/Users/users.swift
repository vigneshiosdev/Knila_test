//
//  users.swift
//  Knila_Test
//
//  Created by Jeyakumar on 03/02/21.
//

import Foundation
import UIKit

struct users : Codable {
    
    var data: [data]?
}

struct data: Codable {
    
    var id: Int?
    var first_name: String?
    var last_name: String?
    var email: String?
    var avatar: String?
    
}
extension data {
    enum CodingKeys: CodingKey {
        case id
        case first_name
        case last_name
        case email
        case avatar
    }
}
