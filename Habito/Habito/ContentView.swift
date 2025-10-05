//
//  ContentView.swift
//  Habito
//
//  Created by Deepankar Das on 03/10/25.
//

import SwiftUI



struct ContentView: View {
    
    @State private var userHabits = Habits()
    @State private var isSheetShow = false
    @State private var naviationPath = NavigationPath()
    var body: some View {
        NavigationStack(path: $naviationPath){
            List{
                ForEach(userHabits.habits) { habit in
                    HabitView(habit: habit)
                }.onDelete(perform: removeItem)
            }.navigationTitle("Habit Tracking")
                .sheet(isPresented: $isSheetShow, content: {
                    AddNewHabit(habits: $userHabits.habits)
                })
                .toolbar{
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button("add", systemImage: "plus") {
                            isSheetShow.toggle()
                        }
                    }
                }
                .navigationDestination(for: Habit.self) { habit in
                    HabitDetails(habit: habit, habits : $userHabits)
                }
                
        }
    }
    
    func addNewHabit(newHabit: Habit){
        withAnimation {
            userHabits.habits.append(newHabit)
        }
    }
    func removeItem(at offSets: IndexSet){
        withAnimation {
            userHabits.habits.remove(atOffsets: offSets)
        }
    }
    
}

#Preview {
    ContentView()
}
