//
//  AddNewHabit.swift
//  Habito
//
//  Created by Deepankar Das on 05/10/25.
//

import SwiftUI

struct AddNewHabit: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var habitName = ""
    @State private var habitDescription = ""
    
    
    @Binding var habits: [Habit]
    
    private var previewData : Habit {
        Habit(title: habitName, description: habitDescription)
    }
    var body: some View {
        NavigationStack{
            Form{
                Section("#Preview"){
                    HabitView(habit: previewData)
                }
                Section("Enter Habit"){
                    TextField("Enter Habit Name", text: $habitName)
                    TextField("Enter Habit Description", text: $habitDescription)
                }
            }.toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("cancel") {
                        dismiss()
                    }
                }
                if (habitName != "" && habitDescription != "") {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save") {
                            habits.append(Habit(title: habitName, description: habitDescription))
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}
#Preview {
    let habits = Habits().habits
    NavigationStack{
        AddNewHabit(habits: .constant(habits))
    }
}
