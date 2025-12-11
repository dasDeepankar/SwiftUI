//
//  Card.swift
//  Flashzilla
//
//  Created by Deepankar Das on 08/12/25.
//

import Foundation
enum SwipeDirection: Codable {
    case wrong
    case correct
}

struct Card: Codable, Identifiable {
    var id = UUID()
    let prompt : String
    let answer : String
    var result : SwipeDirection? = nil
    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}

@Observable
class UserCards {
    var cards : [Card]
    var isActive: Bool = true
    var newPrompt = ""
    var newAnswer = ""
    
    init() {
        if let data:[Card] =  FileManager.default.decode(file: "cards.json"){
            self.cards = data
        }else{
            cards = [Card]()
        }
        
    }
    func removeCard(at index: Int, for direction: SwipeDirection) {
        guard index >= 0  else { return }
        
        if direction == .wrong {
            var card = cards[index]
            cards.remove(at: index)
            card.id = UUID()  // Give a new unique ID so ForEach treats it as a new card
            cards.insert(card, at: 0)  // Insert at bottom of stack
        } else {
            cards.remove(at: index)
        }
        
        if cards.isEmpty {
            isActive = false
        }
    }
    func loadData() {
        if let data:[Card] =  FileManager.default.decode(file: "cards.json"){
            self.cards = data
        }else{
            cards = [Card]()
        }
    }
    func saveData(){
        FileManager.default.encode(data: cards, file: "cards.json")
    }
    func addCard() {
        let trimedPrompt = newPrompt.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimedAnswer = newAnswer.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimedPrompt.isEmpty, !trimedAnswer.isEmpty else {
            return
        }
        let newCard = Card(prompt: trimedPrompt, answer: trimedAnswer)
        cards.insert(newCard, at: 0)
        saveData()
        newPrompt = ""
        newAnswer = ""
    }
}
