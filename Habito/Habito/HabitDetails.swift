//
//  HabitDetails.swift
//  Habito
//
//  Created by Deepankar Das on 05/10/25.
//

import SwiftUI

struct HabitDetails: View {
    var habit: Habit
    @State private var title = ""
    @State private var description = ""
    @State private var isEditing = false
    
    @Binding var habits : Habits
    
    // Compute the current habit from the habits array to reflect real-time updates
    private var currentHabit: Habit {
        habits.habits.first(where: { $0.id == habit.id }) ?? habit
    }
    
    
    var body: some View {
        Form{
            Section("Habit Name"){
                if(isEditing == true ){
                    TextField(currentHabit.title, text: $title)
                }else{
                    Text(currentHabit.title)
                }
            }
            Section("Habit Desription"){
                if(isEditing == true ){
                    TextField(currentHabit.description, text: $description)
                    
                }else{
                    Text(currentHabit.description)
                }
            }
            Section("Completion Count : \(currentHabit.completionCount)"){
                Button {
                    updateHabit(habitTitle: currentHabit.title, habitDescription: currentHabit.description, count: 1)
                } label: {
                    HStack{
                        Spacer()
                        Text("Add Completion")
                        Image(systemName: "plus")
                        Spacer()
                    }
                }
                
            }
        }.toolbar {
            if(isEditing == true){
                Button("Save") {
                    updateHabit(habitTitle: title, habitDescription: description, count: 0)
                    isEditing.toggle()
                }
                
            }else{
                Button("Edit", systemImage: "pencil") {
                    title = currentHabit.title
                    description = currentHabit.description
                    isEditing.toggle()
                }
            }
            
        }
    }
    
    func updateHabit(habitTitle : String , habitDescription : String , count : Int){
        guard let index = habits.habits.firstIndex(where: { $0.id == habit.id }) else { return }
        let currentCount = habits.habits[index].completionCount + count
        var updatedHabit = habits.habits[index]
        updatedHabit.title = habitTitle
        updatedHabit.description = habitDescription
        updatedHabit.completionCount = currentCount
        habits.habits[index] = updatedHabit
    }
    
}

#Preview {
    let habit = Habit(title: "Test", description: "Test")
    let habits = Habits()
    NavigationStack {
        HabitDetails(habit: habit, habits: .constant(habits))
    }
    
}
