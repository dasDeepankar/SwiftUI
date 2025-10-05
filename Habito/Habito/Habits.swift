//
//  Habits.swift
//  Habito
//
//  Created by Deepankar Das on 05/10/25.
//

import Foundation

struct Habit: Identifiable, Hashable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var description: String
    var completionCount: Int = 0
}
@Observable
class Habits {
    var habits : [Habit] {
        didSet {
            if let encodeData = try? JSONEncoder().encode(habits) {
                UserDefaults.standard.set(encodeData, forKey: "habits")
            }
        }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "habits"), let decodedData = try? JSONDecoder().decode([Habit].self, from: data) {
            self.habits = decodedData
        } else {
            self.habits = [ Habit(title: "learning a language", description: "Tap to See Details"),
                            Habit(title: "practicing an instrument", description: "Tap to See Details"),
                            Habit(title: "exercising", description: "Tap to See Details")]
        }
    }
}
