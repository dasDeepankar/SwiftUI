//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Deepankar Das on 22/08/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var scoreTitle: String = ""
    @State private var showScoreAlert: Bool = false
    @State private var score = 0
    @State private var questionNumber = 1
    @State private var showFinalScore: Bool = false
    
    
    @State private var flagRotationAmount = 0.0
    @State private var showAnimation = false
    @State private var tappedFlagIndex: Int? = nil
    
    private let totalQuestions = 8
    
    private struct FlagImage: View {
        let labels = [
            "Estonia": "Flag with three horizontal stripes. Top stripe blue, middle stripe black, bottom stripe white.",
            "France": "Flag with three vertical stripes. Left stripe blue, middle stripe white, right stripe red.",
            "Germany": "Flag with three horizontal stripes. Top stripe black, middle stripe red, bottom stripe gold.",
            "Ireland": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe orange.",
            "Italy": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe red.",
            "Nigeria": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe green.",
            "Poland": "Flag with two horizontal stripes. Top stripe white, bottom stripe red.",
            "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red.",
            "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background.",
            "Ukraine": "Flag with two horizontal stripes. Top stripe blue, bottom stripe yellow.",
            "US": "Flag with many red and white stripes, with white stars on a blue background in the top-left corner."
        ]
        fileprivate let flagName : String
        var body : some View {
            Image(flagName)
                .clipShape(.rect(cornerRadius: 8))
                .shadow(radius: 5)
                .accessibilityLabel(labels[flagName, default: "Unknown Flag"])
            
        }
    }
    
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
                
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                //accessibilityInputLabels
//                Button("John Fitzgerald Kennedy") {
//                    print("Button tapped")
//                }.accessibilityInputLabels(["John Fitzgerald Kennedy", "Kennedy", "JFK"])
                Text("Question \(questionNumber) of \(8)")
                    .font(.subheadline.weight(.heavy))
                    .foregroundColor(.white)
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap On The Flag")
                            .font(.subheadline.weight(.heavy))
                            .foregroundColor(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.bold())
                        
                    }
                    ForEach(0..<3) { number in
                        Button{
                            onFlagTapped(number)
                        }label: {
                            FlagImage(flagName: countries[number])
                                .rotation3DEffect(.degrees(showAnimation && tappedFlagIndex == number ? flagRotationAmount : 0.0)  , axis: (x: 0, y: 1, z: 0))
                                .scaleEffect(correctAnswer != number && showAnimation ? 0.9 : 1.0)
                                .opacity(correctAnswer != number && showAnimation ? 0.25 : 1.0)
                            
                            
                        }
                        .disabled(showScoreAlert)
                    }
                    
                }.frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.regularMaterial)
                    .clipShape(.rect(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
                if showScoreAlert {
                    VStack {
                        Button{
                            askQuestion()
                        }label: {
                            Text(scoreTitle)
                                .font(.subheadline.weight(.heavy))
                                .foregroundColor(Color(red: 0.76, green: 0.15, blue: 0.26))
                            
                        }
                    }   .padding(15)
                        .background(.white)
                        .clipShape(.capsule)
                    
                }
                Spacer()
            }.padding()
        }
        .alert("🥳 Congratulations 🎉\nTap Reset to Play Again", isPresented: $showFinalScore) {
            Button("Reset", action: resetQuestion)
        }message: {
            Text("Your Final Score is : \(score)")
        }
    }
    
    func onFlagTapped(_ userAnswer: Int) {
        tappedFlagIndex = userAnswer
        withAnimation(.easeInOut(duration: 0.5)) {
            flagRotationAmount = 360
        }
        if userAnswer == correctAnswer {
            scoreTitle = "Correct"
            score += 5
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[userAnswer])"
        }
        withAnimation(.easeInOut(duration: 0.5)) {
            showAnimation = true
            showScoreAlert = true
        }
        
    }
    
    func shuffleQuestions() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    func askQuestion() {
        withAnimation(.easeInOut(duration: 0.5)){
            showScoreAlert = false
        }
        
        if(questionNumber == totalQuestions){
            showFinalScore = true
            return
        }
        questionNumber += 1
        flagRotationAmount = 0.0
        showAnimation = false
        tappedFlagIndex = nil
        shuffleQuestions()
    }
    func resetQuestion() {
        showFinalScore = false
        questionNumber = 1
        score = 0
        shuffleQuestions()
        flagRotationAmount = 0.0
        showAnimation = false
        tappedFlagIndex = nil
    }
}

#Preview {
    ContentView()
}
