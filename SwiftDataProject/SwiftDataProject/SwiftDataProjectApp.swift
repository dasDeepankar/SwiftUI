//
//  SwiftDataProjectApp.swift
//  SwiftDataProject
//
//  Created by Deepankar Das on 21/10/25.
//
import SwiftData
import SwiftUI

@main
struct SwiftDataProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: User.self)
    }
}
