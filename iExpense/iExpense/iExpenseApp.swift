//
//  iExpenseApp.swift
//  iExpense
//
//  Created by Deepankar Das on 13/09/25.
//

import SwiftData
import SwiftUI

@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: Expense.self)
    }
}
