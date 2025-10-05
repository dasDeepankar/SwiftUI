//
//  ContentView.swift
//  Navigation
//
//  Created by Deepankar Das on 25/09/25.
//

import SwiftUI

@Observable
class PathStore {
    var path : NavigationPath {
        didSet {
            save()
        }
    }
    private let savePath = URL.documentsDirectory.appending(path: "SavedPath")
    
    init() {
        if let data = try? Data(contentsOf: savePath){
            
            if let decodeData = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data){
                path = NavigationPath(decodeData)
                return
            }
        }
        path = NavigationPath()
    }
    
    func save() {
        guard let respesentable = path.codable else { return  }
        
        do{
            let data = try JSONEncoder().encode(respesentable)
            try data.write(to: savePath)
        }catch{
            print("not able to write to path ",error)
        }
    }
}


struct Student : Identifiable , Hashable {
    var id = UUID()
    var name : String
    var age : Int
}
struct Employee : Identifiable, Hashable {
    var id = UUID()
    var name : String
    var age : Int
}
struct DetailView : View {
    @Binding  var path : NavigationPath
    var number : Int
    
    @State private var title = "This is detail"
    
    var body: some View {
        NavigationLink("Navigate to \(number)", value: Int.random(in: 1...1000))
            .navigationTitle($title)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Home", systemImage: "house") {
                        path = NavigationPath()
                    }
                    EditButton()
                }
               
            }
            .navigationBarTitleDisplayMode(.inline)
//            .toolbarBackground(.black)
//            .toolbarColorScheme(.dark)
            
           
            
    }
    
}

struct ContentView: View {
    let students: [Student] = [Student( name: "student1", age: 22),
                               Student( name: "student2", age: 22),
                               Student( name: "student3", age: 22),
                               Student( name: "student4", age: 22),
                               Student( name: "student5", age: 22) ]
    
    @State private var pathStore = PathStore()
    
    
    var body: some View {
        NavigationStack(path: $pathStore.path){
            List(students){ student in
                Button("Push student \(student.name)"){
                    pathStore.path.append(Student(name: student.name, age: student.age))
                }
            }.navigationDestination(for: Student.self) { student in
                Text(student.name)
            }
            DetailView(path:  $pathStore.path, number: 0)
            VStack{
                Button("Push employee 1"){
                    pathStore.path.append(Employee(name: "emp1", age: 22))
                }
                Button("Push employee 2"){
                    pathStore.path.append(Employee(name: "emp2", age: 22))
                }
                Button("Push employee 3 and 4") {
                    pathStore.path.append(Employee(name: "emp3", age: 22))
                    pathStore.path.append(Employee(name: "emp4", age: 23))
                }
            }.navigationDestination(for: Employee.self) { selection in
                Text("employee: \(selection.name)")
            }
            .navigationDestination(for: Student.self) { selection in
                Text("student: \(selection.name)")
            }
            .navigationDestination(for: Int.self) { number in
                DetailView(path: $pathStore.path, number: number)
            }
        }
    }
}

#Preview {
    ContentView()
}
