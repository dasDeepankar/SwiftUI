//
//  UserDetails.swift
//  Friendface
//
//  Created by Deepankar Das on 02/11/25.
//

import SwiftUI

struct UserDetails: View {
    var user : User
    var body: some View {
        Form{
            Section{
                HStack{
                    Label(user.name, systemImage: "person.circle")
                    Spacer()
                    Image(systemName: "\(user.age).circle.fill")
                    
                }
                Label(user.email, systemImage: "mail")
                Label(user.company, systemImage: "info.circle.text.page")
                Label(user.registered.formatted(date: .long, time: .omitted), systemImage: "calendar")
            }
            Section("#tags"){
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(user.tags, id: \.self){
                            Text("#\($0)").font(.subheadline)
                                .padding(8)
                        }
                    }
                }
            }
            Section("about"){
                Text("Occaecat consequat elit aliquip magna laboris dolore laboris sunt officia adipisicing reprehenderit sunt. Do in proident consectetur labore. Laboris pariatur quis incididunt nostrud labore ad cillum veniam ipsum ullamco. Dolore laborum commodo veniam nisi. Eu ullamco cillum ex nostrud fugiat eu consequat enim cupidatat. Non incididunt fugiat cupidatat reprehenderit nostrud eiusmod eu sit minim do amet qui cupidatat. Elit aliquip nisi ea veniam proident dolore exercitation irure est deserunt.")
                }
            Section("friends"){
                List(user.friends, id: \.id) { friend in
                    Text(friend.name)
                }
            }
        }.navigationTitle("User Info")
    }
}

#Preview {
    let mockUser = User(
        id: "50a48fa3-2c0f-4397-ac50-64da464f9954",
        isActive: false,
        name: "Alford Rodriguez",
        age: 21,
        company: "Imkan",
        email: "alfordrodriguez@imkan.com",
        address: "907 Nelson Street, Cotopaxi, South Dakota, 5913",
        about: "Occaecat consequat elit aliquip magna laboris dolore laboris sunt officia adipisicing reprehenderit sunt. Do in proident consectetur labore. Laboris pariatur quis incididunt nostrud labore ad cillum veniam ipsum ullamco.",
        registered: ISO8601DateFormatter().date(from: "2015-11-10T01:47:18-00:00") ?? Date(),
        tags: [
            "cillum", "consequat", "deserunt", "nostrud", "eiusmod", "minim", "tempor"
        ],
        friends: [
            Friend(id: "91b5be3d-9a19-4ac2-b2ce-89cc41884ed0", name: "Hawkins Patel"),
            Friend(id: "0c395a95-57e2-4d53-b4f6-9b9e46a32cf6", name: "Jewel Sexton"),
            Friend(id: "be5918a3-8dc2-4f77-947c-7d02f69a58fe", name: "Berger Robertson")
        ]
    )
    NavigationStack{
        UserDetails(user: mockUser)
    }
}
