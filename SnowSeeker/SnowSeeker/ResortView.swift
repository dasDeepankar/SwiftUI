//
//  ResortView.swift
//  SnowSeeker
//
//  Created by Deepankar Das on 27/12/25.
//

import SwiftUI

struct ResortView: View {
    let resort : Resort
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(Favorites.self) var favorites
    
    @State private var selectedFacility : Facility?
    @State private var showingFacility = false
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0){
                ZStack(alignment: .bottomTrailing){
                    Image(decorative: resort.id)
                        .resizable()
                        .scaledToFit()
                    Label(resort.imageCredit, systemImage: "camera")
                        .font(.headline)
                        .padding(8)
                        .background(.black.opacity(0.5))
                        .foregroundStyle(.white)
                   
                }
                HStack {
                    if horizontalSizeClass == .compact && dynamicTypeSize > .large{
                        VStack(spacing : 10){ ResortDetailsView(resort: resort) }
                        VStack(spacing : 10){ SkiDetailsView(resort: resort) }
                    }else{
                        ResortDetailsView(resort: resort)
                        SkiDetailsView(resort: resort)
                    }
                }
                .padding(.vertical)
                .background(.primary.opacity(0.1))
                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                Group{
                    Text(resort.description)
                        .padding(.vertical)
                    
                    Text("Facilities")
                        .font(.headline)
                    
                    HStack {
                        ForEach(resort.facilityTypes) { facility in
                            Button {
                                 selectedFacility = facility
                                 showingFacility = true
                             } label: {
                                 facility.icon
                                     .font(.title)
                             }
                        }
                    }
                }.padding(.horizontal)
                Button(favorites.contains(resort) ? "Remove from Favorites" : "Add to Favorites") {
                    if favorites.contains(resort) {
                        favorites.remove(resort)
                    } else {
                        favorites.add(resort)
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
        .navigationTitle("\(resort.name), \(resort.country)")
        .navigationBarTitleDisplayMode(.inline)
        .alert(selectedFacility?.name ?? "More information", isPresented: $showingFacility, presenting: selectedFacility) { _ in
        } message: { facility in
            Text(facility.description)
        }
        
    }
}

#Preview {
    let favorites = Favorites()
    NavigationStack{
        ResortView(resort: .example).environment(favorites)
    }
}
