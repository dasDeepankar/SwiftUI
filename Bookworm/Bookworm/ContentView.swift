//
//  ContentView.swift
//  Bookworm
//
//  Created by Deepankar Das on 13/10/25.
//
import SwiftData
import SwiftUI

struct ContentView: View {
    @Query(sort : [
        SortDescriptor(\Book.title),
        SortDescriptor(\Book.author)
    ]) var books : [Book]
    @State private var isSheetPresented: Bool = false
    @Environment(\.modelContext) var modelContext
    

    
    var body: some View {
        NavigationStack{
            List{
                ForEach(books) { book in
                    NavigationLink(value: book) {
                        HStack{
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            VStack(alignment: .leading){
                                Text(book.title)
                                    .font(.headline)
                                    .foregroundStyle(titleColor(for: book.rating))
                                Text(book.author)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }.onDelete(perform: deleteBook)
            }.navigationTitle("Bookworm")
                .toolbar{
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add New Book", systemImage: "plus") {
                            isSheetPresented.toggle()
                        }
                    }
                }
                .sheet(isPresented: $isSheetPresented) {
                    AddNewBook()
                }
                .navigationDestination(for: Book.self) { book in
                    DetailView(book: book)
                }
        }
    }
    
    func deleteBook(offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            modelContext.delete(book)
        }
    }
    func titleColor(for rating: Int) -> Color {
        rating > 1 ? .primary : .red
    }
}

#Preview {
    ContentView()
}
