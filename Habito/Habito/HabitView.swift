//
//  HabitView.swift
//  Habito
//
//  Created by Deepankar Das on 05/10/25.
//

import SwiftUI

struct HabitView: View {
    var habit: Habit
    var body: some View {
        NavigationLink(value: habit) {
            HStack{
                VStack(alignment: .leading){
                    Text(habit.title)
                        .font(.headline)
                    Text(habit.description)
                        .font(.subheadline)
                }
                Spacer()
                Image(systemName:"\(habit.completionCount).circle.fill" )
            }
        }
    }
}

#Preview {
    let habit = Habit(title: "Test", description: "Test")
    HabitView(habit: habit)
}
