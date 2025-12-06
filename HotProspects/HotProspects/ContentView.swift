//
//  ContentView.swift
//  HotProspects
//
//  Created by Deepankar Das on 29/11/25.
//

import SwiftUI


struct ContentView: View {
    
    var body: some View {
        TabView{
            Tab("Everyone", systemImage: "person.3") {
                ProspectsView(filter: .none)
            }
            Tab("Contacted", systemImage: "checkmark.circle") {
                ProspectsView(filter: .contacted)
            }
            Tab("Uncontacted", systemImage: "questionmark.diamond") {
                ProspectsView(filter: .uncontacted)
            }
            Tab("Me", systemImage: "person.crop.square") {
                MeView()
            }
            
        }.tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    ContentView()
}
