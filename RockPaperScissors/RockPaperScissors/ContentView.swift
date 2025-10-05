//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Deepankar Das on 27/08/25.
//

import SwiftUI

struct ContentView: View {
    
    private var options: [String] = ["👊", "🫱", "✌️"]
    
    @State private var gameRandomChoice = Int.random(in: 0..<3)
    @State private var shouldWin = Bool.random()
    
    @State private var gameMove = 1
    
    fileprivate let totalMoves = 10
    
    @State private var score: Int = 0
    
    @State private var showScoreAlert: Bool = false
    
    @State private var alertTitle: String  = ""
    
    @State private var gameEnded: Bool = false
    
    @State private var playerMove: String = ""
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [.black, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Spacer()
                Text("\(gameMove) / \(totalMoves) Moves")
                    .font(.headline)
                Text("You Should \(shouldWin ? "Win" : "Lose")")
                    .font(.largeTitle)
                Spacer()
                Text(options[gameRandomChoice])
                    .font(.system(size: 200))
                Spacer()
                Text("Choose Your Move ??")
                    .font(.title)
                Spacer()
                HStack(spacing: 20){
                    ForEach(options , id: \.self) { option in
                        Button{
                            validateMove(for: option)
                        }label: {
                            Text(option)
                                .font(.system(size: 60))
                        }.buttonStyle(.borderedProminent)
                            .disabled(gameEnded)
                    }
                }
                Spacer()
                Text("Score : \(score)")
                    .font(.largeTitle)
                Spacer()
            }
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding()
        }
        .alert(alertTitle, isPresented: $showScoreAlert) {
            Button("Continue", action: nextMove)
        } message: {
            Text("Why?? \n Game Move: \(options[gameRandomChoice]) vs Player Move: \(playerMove) \n You have to \(shouldWin ? "WIN" : "LOSE") to WIN this round."  )
            
        }
        .alert(alertTitle, isPresented: $gameEnded) {
            Button("New Game", action: resetGame)
        } message: {
            Text("Final Score: \(score)")
        }
    }
    
    func nextMove() {
        if gameMove >= totalMoves {
            showScoreAlert = false
            gameEnded = true
            alertTitle = "Game Over! 🎯"
            return
        }
        
        gameRandomChoice = Int.random(in: 0..<3)
        shouldWin.toggle()
        gameMove += 1
    }
    
    func resetGame() {
        gameRandomChoice = Int.random(in: 0..<3)
        shouldWin.toggle()
        gameMove = 1
        score = 0
        gameEnded = false
    }
    
    func validateMove(for userChoice: String)  {
        let gameChoice = options[gameRandomChoice]
        playerMove = userChoice
        // Check if it's a tie first
        if userChoice == gameChoice {
            alertTitle = "It's a Tie! 🤝"
        } else {
            // Check win conditions
            let isPlayerWin = checkWin(userChoice: userChoice, gameChoice: gameChoice)
            
            if isPlayerWin == shouldWin {
                alertTitle = "You Win! 🏆"
                score += 5
            } else {
                alertTitle = "You Lose! 😭"
            }
        }
        
        showScoreAlert = true
    }
    
    func checkWin(userChoice: String, gameChoice: String) -> Bool {
        // Rock beats Scissors, Paper beats Rock, Scissors beats Paper
        if (userChoice == "👊" && gameChoice == "✌️") ||
            (userChoice == "🫱" && gameChoice == "👊") ||
            (userChoice == "✌️" && gameChoice == "🫱") {
            return true  
        }
        return false
    }
}

#Preview {
    ContentView()
}
