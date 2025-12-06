//
//  Prospect.swift
//  HotProspects
//
//  Created by Deepankar Das on 02/12/25.
//

import SwiftUI
import SwiftData

@Model
class Prospect {
    var name: String
    var emailAddress: String
    var isContacted: Bool
    var date : Date
    
    init(name: String, emailAddress: String, isContacted: Bool) {
        self.name = name
        self.emailAddress = emailAddress
        self.isContacted = isContacted
        self.date = Date()
    }
}
