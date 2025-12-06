//
//  EditView.swift
//  HotProspects
//
//  Created by Deepankar Das on 05/12/25.
//
import SwiftData
import SwiftUI



struct EditView: View {
    @State private var name = ""
    @State private var emailAddress = ""
    @State private var isContacted = false
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    var toggleData: (title: String, icon: String, tintColor: Color) {
        if isContacted {
            return ( "Contacted", "person.fill.checkmark", .green)
        }
        else {
            return ( "Not Contacted", "person.fill.xmark", .gray)
        }
    }
    var prospect: Prospect
    var body: some View {
        NavigationStack{
            Form{
                TextField("Name", text: $name)
                TextField("Email", text: $emailAddress)
                
                Section("Toggle Contacted"){
                    Toggle("Contacted", systemImage: toggleData.icon, isOn: $isContacted)
                }
            }
            .navigationTitle("Edit Prospect")
            .toolbar {
                Button("Save") {
                    prospect.name = name
                    prospect.emailAddress = emailAddress
                    prospect.isContacted = isContacted
                    dismiss()
                }
            }
            
        }
    }
    init(prospect: Prospect) {
        self.prospect = prospect
        _name = State(initialValue: prospect.name)
        _emailAddress = State(initialValue: prospect.emailAddress)
        _isContacted = State(initialValue: prospect.isContacted)
    }
}

#Preview {
    NavigationStack{
        EditView(prospect: Prospect(name: "text", emailAddress: "text.some@gmail.com", isContacted: false))
    }
}
