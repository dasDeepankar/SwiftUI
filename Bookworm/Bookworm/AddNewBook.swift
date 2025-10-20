//
//  AddNewBook.swift
//  Bookworm
//
//  Created by Deepankar Das on 14/10/25.
//

import SwiftData
import SwiftUI

struct AddNewBook: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var genre = ""
    @State private var rating = 1
    @State private var review = ""
   
    
    private let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    private var isSaveDisabled: Bool {
        if title.isBlank || author.isBlank || review.isBlank || genre.isBlank{
            return true
        }
        return false
    }
    
    var body: some View {
        Form{
            Section{
                TextField("Name", text: $title)
                TextField("Author", text: $author)
            }

            Picker(selection: $genre, label: Text("Genre")){
                ForEach(genres, id: \.self){
                    Text($0)
                }
            }
            
            Section("Write a Review"){
                TextEditor(text: $review)
                RatingView(rating: $rating)
            }
            Button("Add Book"){
                let newBook = Book(id: UUID(), title: title, author: author, genre: genre, rating: rating, review: review)
                modelContext.insert(newBook)
                dismiss()
                
            }.disabled(isSaveDisabled)
        }
    }
}

#Preview {
    AddNewBook()
}
