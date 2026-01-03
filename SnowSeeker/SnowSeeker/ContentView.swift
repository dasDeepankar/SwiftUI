//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Deepankar Das on 26/12/25.
//

import SwiftUI

enum sortTypes {
    case defaultOrder, country, alphabetical
}

struct ContentView: View {
    let resorts : [Resort] = Bundle.main.decode("resorts.json")
    @State private var searchText = ""
    @State private var selectedSort: sortTypes = .defaultOrder
    
    var filteredResorts: [Resort] {
        let filtered: [Resort]
        
        if searchText.isEmpty {
            filtered = resorts
        } else {
            filtered = resorts.filter { $0.name.localizedStandardContains(searchText) }
        }
        
        switch selectedSort {
        case .defaultOrder:
            return filtered
        case .country:
            return filtered.sorted(by: { $0.country < $1.country })
        case .alphabetical:
            return filtered.sorted(by: { $0.name < $1.name })
        }
    }
    @State private var favorites = Favorites()
    
    var sortLabel: String {
        switch selectedSort {
        case .defaultOrder:
            return "Default"
        case .alphabetical:
            return "Alphabetical"
        case .country:
            return "Country"
        }
    }
    
    var body: some View {
        NavigationSplitView{
            List(filteredResorts) { resort in
                NavigationLink(value: resort) {
                    HStack{
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(.rect(cornerRadius: 5))
                            .overlay {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 1)
                            }
                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .foregroundStyle(.secondary)
                        }
                        if favorites.contains(resort) {
                            Spacer()
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("This is a favorite resort")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
            .navigationTitle("Resorts")
            .navigationDestination(for: Resort.self, destination: { resort in
                ResortView(resort: resort)
            })
            .searchable(text: $searchText, prompt: "Search for a resort")
            .toolbar {
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker("Sort", selection: $selectedSort) {
                        Text("Default")
                            .tag(sortTypes.defaultOrder)
                        Text("Alphabetical")
                            .tag(sortTypes.alphabetical)
                        Text("Country")
                            .tag(sortTypes.country)
                    }
                }
            }
        }detail: {
            WelcomeView()
        }
        .environment(favorites)
    }
}

#Preview {
    ContentView()
}
