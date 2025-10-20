//
//  BookDetailsView.swift
//  Bookworm
//
//  Created by Deepankar Das on 17/10/25.
//
import SwiftData
import SwiftUI

struct DetailView: View {
    let book: Book
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @State private var isDeleteAlertShown: Bool = false
    
    var body: some View {
        ScrollView{
            ZStack(alignment: .bottomTrailing){
                Image(book.genre)
                    .resizable()
                    .scaledToFit()
                Text(book.genre.uppercased())
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(8)
                    .foregroundStyle(.white)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)
                    .offset(x: -5, y: -5)
            }
            VStack(spacing: 40){
                HStack(){
                    VStack(alignment : .leading, spacing: 8){
                        Text(book.title)
                            .font(.title)
                            .fontWeight(.bold)
                        Label(book.author, systemImage: "person")
                    }
                    Spacer()
                    
                }
                HStack(){
                    VStack(alignment : .leading, spacing: 20){
                        Text(book.review)
                        RatingView(rating: .constant(book.rating))
                    }
                    Spacer()
                    
                }.padding()
                    .background(.secondary.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                HStack(){
                    VStack(alignment : .leading, spacing: 8){
                        Label("Added to library", systemImage: "calendar")
                        Text(book.date, style: .date)
                    }
                    Spacer()
                    
                }.padding()
                    .background(.secondary.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
            }.padding(.horizontal)
            
            
        }.navigationTitle(book.title)
            .navigationBarTitleDisplayMode(.inline)
            .scrollBounceBehavior(.basedOnSize)
            .toolbar {
                Button("Delete" , systemImage: "trash"){
                    isDeleteAlertShown = true
                }
            }
            .alert("Delete Book", isPresented: $isDeleteAlertShown) {
                
                Button("Delete", role: .destructive , action: deleteBook)
                Button("Cancel", role: .cancel) {}
                
            } message: {
                Text("Are you sure?")
            }
    }
    func deleteBook() {
        modelContext.delete(book)
        dismiss()
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try?  ModelContainer(for: Book.self, configurations: config)
        let mockBook = Book(id: UUID(), title: "Hello", author: "World", genre: "Fantasy", rating: 3, review: "Hello World")
        return  NavigationStack{
            DetailView(book: mockBook)
        }
        
    }catch{
        return Text("Error In Preview \(error.localizedDescription)")
    }
    
}
