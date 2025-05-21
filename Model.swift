//
//  Model.swift
//  ShinyShiftTwo
//
//  Created by Zaidan Akmal on 18/05/25.
//

import Foundation
import SwiftData

@Model
class Member: Identifiable {
    var id: UUID
    var name: String
    var phone: String
    var address: String
    var isActive: Bool
    var photo: Data?

    init(id: UUID = UUID(), name: String, phone: String, address: String, isActive: Bool = true, photo: Data? = nil) {
        self.id = id
        self.name = name
        self.phone = phone
        self.address = address
        self.isActive = isActive
        self.photo = photo
    }
}






