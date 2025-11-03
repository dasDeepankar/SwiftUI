//
//  FriendfaceApp.swift
//  Friendface
//
//  Created by Deepankar Das on 02/11/25.
//
import SwiftData
import SwiftUI

@main
struct FriendfaceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: User.self)
    }
}
