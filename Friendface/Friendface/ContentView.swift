//
//  ContentView.swift
//  Friendface
//
//  Created by Deepankar Das on 02/11/25.
//
import SwiftData
import SwiftUI

struct ContentView: View {
    
    @Query(
        filter: #Predicate<User> {user in
            user.isActive == true
        },
        sort: [
        SortDescriptor(\User.name)
    ],
    ) var users: [User]
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(users, id: \.id) { user in
                    NavigationLink(value: user) {
                            VStack(alignment: .leading){
                                Text(user.name)
                                    .font(.headline)
                                Text(user.email)
                                    .font(.subheadline)
                            }
                    }
                }
            }.task {
                if users.isEmpty {
                    await loadUsers()
                }
               
            }
            .navigationTitle("Friendface")
            .navigationDestination(for: User.self) { user in
                UserDetails(user: user)
            }
        }
    }
    
    
    func loadUsers() async {
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("Error in URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            if let decodedUsers = try? decoder.decode([User].self, from: data){
                for user in decodedUsers {
                    modelContext.insert(user)
                }
            }
            print("not able to decode")
            
            
        }catch {
            print("Error in fetch \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}
