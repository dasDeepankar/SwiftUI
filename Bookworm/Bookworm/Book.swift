//
//  Book.swift
//  Bookworm
//
//  Created by Deepankar Das on 14/10/25.
//
import SwiftData
import Foundation

@Model
class Book {
    var id: UUID
    var title: String
    var author: String
    var genre: String
    var rating: Int
    var review: String
    var date: Date
    
    init(id: UUID = UUID(),
         title: String = "Unknown",
         author: String = "Unknown",
         genre: String = "Unknown",
         rating: Int = 1,
         review: String = "Unknown") {
        self.id = id
        self.title = title
        self.author = author
        self.genre = genre
        self.rating = rating
        self.review = review
        self.date = Date.now
    }
}
