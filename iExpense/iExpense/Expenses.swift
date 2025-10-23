//
//  Expenses.swift
//  iExpense
//
//  Created by Deepankar Das on 23/10/25.
//

import Foundation
import SwiftData


@Model
class Expense {
    var name : String
    var type : String
    var amount : Double
    
    init(name: String, type: String, amount: Double) {
        self.name = name
        self.type = type
        self.amount = amount
    }
}
