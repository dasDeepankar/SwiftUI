//
//  EditView.swift
//  BucketList
//
//  Created by Deepankar Das on 20/11/25.
//

import SwiftUI

struct EditView: View {
    
    @Environment(\.dismiss) var dismiss
    var onSave: (Location) -> Void
    
    @State private var viewModel : ViewModel
    
    var body: some View {
        NavigationStack{
            Form{
                TextField("Name", text: $viewModel.name)
                TextField("Description", text: $viewModel.description)
                Section("Nearby..."){
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            HStack() {
                                VStack{
                                    Text("\(page.title) : ")
                                        .font(.headline)
                                    Spacer()
                                }
                                
                                Text(page.description)
                                    .italic()
                            }
                        }
                    case .failed:
                        Text("Please try again.")
                    }
                }
            }.navigationTitle("Edit Location")
                .toolbar {
                    Button("Save"){
                        onSave(viewModel.updatedLocation())
                        dismiss()
                    }
                }
                .task {
                    await viewModel.fetchNearByPlaces()
                }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.onSave = onSave
        _viewModel = State(initialValue: ViewModel(location: location))
    }

}

#Preview {
    EditView(location: Location.example, onSave: {_ in })
}
