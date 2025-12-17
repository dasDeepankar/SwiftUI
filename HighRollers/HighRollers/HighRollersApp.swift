//
//  HighRollersApp.swift
//  HighRollers
//
//  Created by Deepankar Das on 16/12/25.
//
import SwiftData
import SwiftUI

@main
struct HighRollersApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: Dice.self)
    }
}
