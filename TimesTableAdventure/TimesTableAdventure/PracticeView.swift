//
//  PracticeView.swift
//  TimesTableAdventure
//
//  Created by Deepankar Das on 11/09/25.
//


import SwiftUI

struct PracticeView : View {
    
    @Binding var score : Int
    @Binding var currentQuestion : Int
    @Binding var numberOfQuestion : Int
    @Binding var userInput : String
    @Binding var showAlert :Bool
    @Binding var gameOver : Bool
    @Binding var alertMessage : String
    
    var questions: [Question]
    
    let numbersInput : [inputNumbers] = [inputNumbers(row:  [1,2,3]),
                                         inputNumbers(row:  [4,5,6]),
                                         inputNumbers(row:  [7,8,9]),
                                         inputNumbers(row:  [0])]
    
    
    var alertTitle : String {
        if (userInput != "_ _ _ _" &&
            (questions[currentQuestion].correctAnswer) == Int(userInput)) {
            return "You are correct!\n The answer is: \(questions[currentQuestion].correctAnswer)"
        }else{
            return "Wrong! The answer is: \(questions[currentQuestion].correctAnswer)"
        }
        
        
    }
    
    let onNextPress: () -> Void
    
    let resetGame : () -> Void
    
    var body: some View {
        VStack{
            Spacer()
            VStack{
                Text("Question \(currentQuestion + 1 ) / \(numberOfQuestion)")
                    .font(.headline)
                    .foregroundColor(Color("primaryTextColor"))
                    .padding()
                Text("Score: \(score)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color("primaryTextColor"))
                
                Text("\(questions[currentQuestion].questionText)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("primaryTextColor"))
                    .padding()
            }
            if (showAlert || gameOver){
                Spacer()
                Text(gameOver ? alertMessage : alertTitle)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .background(Color("alertColor"))
                    .foregroundColor(Color("reversePrimaryTextColor"))
                    .clipShape(.buttonBorder)
            }
            else{
                VStack{
                    HStack{
                        Spacer()
                        Spacer()
                        VStack{
                            Text("\(userInput)")
                                .padding()
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(Color("primaryTextColor"))
                        }
                        Spacer()
                        Button{
                            userInput = "_ _ _ _"
                        }label: {
                            Image(systemName: "clear").scaleEffect(2.0)
                                .padding(.horizontal)
                        }
                    }.padding()
                    
                    ForEach(0..<numbersInput.count, id : \.self ){ index in
                        HStack{
                            ForEach(0..<numbersInput[index].row.count, id : \.self ){ number in
                                Button{
                                    if (userInput == "_ _ _ _"){
                                        userInput = ""
                                    }
                                    userInput += "\(numbersInput[index].row[number])"
                                }label: {
                                    Text("\(numbersInput[index].row[number])")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                    }
                }
                .padding()
                
                
            }
            
            Spacer()
            if(showAlert){
                Button{
                    onNextPress()
                }label: {
                    Text("Next")
                        .font(.headline)
                        .padding()
                        .background(Color("primaryButtonColor"))
                        .foregroundColor(Color("primaryTextColor"))
                        .clipShape(.buttonBorder)
                    
                }
            } else if (gameOver){
                Button{
                    resetGame()
                }label: {
                    Text("New Game")
                        .font(.headline)
                        .padding()
                        .background(Color("primaryButtonColor"))
                        .foregroundColor(Color("primaryTextColor"))
                        .clipShape(.buttonBorder)
                    
                }
            }
            else{
                Button{
                    score += 5
                    showAlert = true
                }label: {
                    Text("Submit")
                        .font(.headline)
                        .padding()
                        .background(Color("primaryButtonColor"))
                        .foregroundColor(Color("primaryTextColor"))
                        .clipShape(.buttonBorder)
                    
                }
            }
            Spacer()
        }
        
    }
    
}
#Preview {
    PracticeView(
        score: .constant(0),
        currentQuestion: .constant(0),
        numberOfQuestion: .constant(5),
        userInput: .constant("_ _ _ _"),
        showAlert: .constant(false),
        gameOver: .constant(false),
        alertMessage: .constant("Game Over! Try Again."),
        questions: [
            Question(questionText: "3 x 4 = ?", correctAnswer: 12),
            Question(questionText: "5 x 6 = ?", correctAnswer: 30)
        ],
        onNextPress: {
            print("Next pressed")
        },
        resetGame: {
            print("Reset game pressed")
        }
    )
}
