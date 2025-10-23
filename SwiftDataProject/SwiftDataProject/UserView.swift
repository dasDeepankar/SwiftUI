//
//  UserView.swift
//  SwiftDataProject
//
//  Created by Deepankar Das on 22/10/25.
//
import SwiftData
import SwiftUI

struct UserView: View {
    @Query var users: [User]
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        List(users) { user in
            HStack{
                Text(user.name)
                Spacer()
                Text(String(user.job.count))
                    .fontWeight(.black)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.capsule)

            }
            
        }
    }
    
    func addUser() {
        let user1 = User(name: "SomeONe", city: "SomeWhere", joinDate: .now)
        modelContext.insert(user1)
        let job1 = Job(name: "Organize sock drawer", priority: 3)
        let job2 = Job(name: "Make plans with Alex", priority: 4)
        user1.job.append(job1)
        user1.job.append(job2)
        
    }
    init(minimumDate : Date, sortOrder : [SortDescriptor<User>]) {
        _users = Query(filter: #Predicate<User> { user in
            user.joinDate >= minimumDate
        }, sort: sortOrder)
    }
}

#Preview {
    UserView(minimumDate: .now, sortOrder: []).modelContainer(for: User.self)
}
