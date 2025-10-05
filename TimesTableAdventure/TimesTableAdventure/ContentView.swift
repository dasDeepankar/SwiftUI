//
//  ContentView.swift
//  TimesTableAdventure
//
//  Created by Deepankar Das on 09/09/25.
//

import SwiftUI


struct Question {
    let questionText : String
    let correctAnswer : Int
}

struct inputNumbers {
    let row : [Int]
    
}



struct ContentView: View {
    
    private let fileNames = [
        "bear", "dog", "gorilla", "owl", "rhino",
        "buffalo", "duck", "hippo", "panda", "sloth",
        "chick", "elephant", "horse", "parrot", "snake",
        "chicken", "frog", "monkey", "penguin", "walrus",
        "cow", "giraffe", "moose", "pig", "whale",
        "crocodile", "goat", "narwhal", "rabbit", "zebra"
    ]
    
    @State private var numberOfQuestion = 5
    
    @State private var questions: [Question] = []
    
    @State private var score: Int = 0
    @State private var currentQuestion = 0
    
    @State private var userInput = "_ _ _ _"
    
    @State private var showAlert  = false
    
    @State private var alertMessage: String = ""
    @State private var gameOver: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color("bgColor").ignoresSafeArea()
                
                if (questions.count == 0 ) {
                    SettingsView(numberOfQuestion: $numberOfQuestion ,questions : $questions )
                }else {
                    PracticeView(
                        score: $score,
                        currentQuestion: $currentQuestion.animation(.easeInOut(duration: 1.5)),
                        numberOfQuestion: $numberOfQuestion,
                        userInput: $userInput,
                        showAlert: $showAlert.animation(.bouncy(duration: 1.5)),
                        gameOver: $gameOver.animation(.bouncy(duration: 1.5)),
                        alertMessage: $alertMessage,
                        questions: questions,
                        onNextPress: {
                            handleNextQuestion()
                        },
                        resetGame: {
                            resetGame()
                        }
                    )
                }
            }
            .navigationBarTitle("Times Table Adventure")
            .toolbar {
                if(questions.count > 0 ){
                    Button("New Game") {
                        questions = []
                        
                    }
                    .buttonStyle(.bordered)
                }
            }
            
        }
    }
    
    func resetGame() {
        questions = []
        score = 0
        userInput = "_ _ _ _"
        gameOver = false
        alertMessage = ""
        showAlert = false
        currentQuestion = 0
    }
    
    func handleNextQuestion() {
        if(currentQuestion == numberOfQuestion - 1 ){
            alertMessage = "Score: \(score)\nCongratulations! You have completed the game. Play again?"
            showAlert = false
            gameOver = true
            return
        }
        
        currentQuestion += 1
        
        
        userInput = "_ _ _ _"
        showAlert = false
        alertMessage = ""
        gameOver = false
    }
    
}
#Preview {
    ContentView()
}
