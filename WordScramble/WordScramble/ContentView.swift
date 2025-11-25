//
//  ContentView.swift
//  WordScramble
//
//  Created by Deepankar Das on 04/09/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var newWord = ""
    @State private var rootWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showError = false
    
    private let scoreValue : Int = 10
    
    private var score : Int {
        guard !usedWords.isEmpty else { return 0 }
        return usedWords.reduce(0) { $0 + $1.count * scoreValue }
    }
    
    var body: some View {
        NavigationStack{
            List{
                Section{
                    TextField("Enter a word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                Section(){
                    Text("Score : \(score)")
                    
                }
                ForEach(usedWords, id: \.self){ word in
                    HStack{
                        Image(systemName: "\(word.count).circle")
                        Text(word)
                    }.accessibilityElement()
//                        .accessibilityLabel("\(word), \(word.count) letters")
                        .accessibilityLabel(word)
                        .accessibilityHint("\(word.count)-letter")
                }
            }.navigationTitle(rootWord)
                .onSubmit(addNewWord)
                .onAppear(perform: startGame)
                .alert(errorTitle, isPresented: $showError) { } message: {
                    Text(errorMessage)
                }
                .toolbar {
                    Button("New Game", action: startGame)
                }
        }
    }
    
    func isGreaterThanTwo(word : String) -> Bool{
        word.count > 2
    }
    func isNotSameAsRoot(word : String) -> Bool{
        word != rootWord
    }
    
    
    func isOriginal(word : String) -> Bool{
        !usedWords.contains(word)
    }
    
    func isPossible(word : String) -> Bool{
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            }else{
                return false
            }
        }
        return true
    }
    
    func isReal(word : String) -> Bool{
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
        
    }
    
    func startGame() {
        if let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: ".txt"){
            if let startWords = try? String.init(contentsOf: startWordsUrl, encoding: .utf8){
                let allwords = startWords.components(separatedBy: "\n")
                rootWord = allwords.randomElement() ?? "silkworm"
                usedWords = []
                return
            }
        }
        fatalError( "Could not load start.txt from the bundle")
    }
    
    func addNewWord(){
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
        
        guard isGreaterThanTwo(word: answer) else {
            errorTitle = "Too short for a Word!"
            errorMessage = "Must Be More than Two Letters"
            showError = true
            return
        }
        guard isNotSameAsRoot(word: answer) else {
            errorTitle = "Same as root Word!"
            errorMessage = "Nice Try But Can not same as root Word"
            showError = true
            return
        }
        guard isOriginal(word: answer) else {
            errorTitle = "Not a original Word!"
            errorMessage = "Please be Original"
            showError = true
            return
        }
        guard isPossible(word: answer) else {
            errorTitle = "Not a possible Word!"
            errorMessage = "Please check your spelling and try again."
            showError = true
            return
        }
        guard isReal(word: answer) else {
            errorTitle = "Not a real Word!"
            errorMessage = "Please check your spelling and try again."
            showError = true
            return
        }
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
        
    }
}

#Preview {
    ContentView()
}
