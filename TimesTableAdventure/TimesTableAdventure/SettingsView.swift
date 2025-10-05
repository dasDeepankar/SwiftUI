//
//  QurstionView.swift
//  TimesTableAdventure
//
//  Created by Deepankar Das on 11/09/25.
//

import SwiftUI



struct SettingsView: View {
    
    private let numberOfQuestions: [Int] = [5, 10, 20]
    @Binding var numberOfQuestion : Int
    @Binding var questions: [Question]
    
    @State private var selectedTable = 2
    
    let tableList : [inputNumbers] = [inputNumbers(row:  [2, 3, 4, 5]),
                                      inputNumbers(row:  [6, 7 ,8 ,9]),
                                      inputNumbers(row:  [10 ,11 ,12])]
    
    let colorNames = [
        "alertColor",
        "SuccessColor",
        "NavigationColor",
        "primaryTextColor",
        
    ]
    
    
    
    var body: some View {
        VStack{
            Spacer()
            VStack{
                Text("select how many questions")
                    .font(.headline)
                    .padding()
                Picker("select how many questions", selection: $numberOfQuestion) {
                    ForEach(numberOfQuestions, id: \.self) { index in
                        Text("\(index) Questions ")
                    }
                }.pickerStyle(.menu)
                    .font(.headline)
            }
            Spacer()
            VStack{
                Text("select multiplication tables: \(selectedTable)")
                                      .font(.headline)
                                      .padding()
                ForEach(0..<tableList.count, id : \.self ){ index in
                    HStack{
                        ForEach(0..<tableList[index].row.count, id : \.self ){ number in
                            Button{
                                selectedTable = tableList[index].row[number]
                            }label: {
                                Text(" \(tableList[index].row[number])")
                                    .font(.headline)
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .background(tableList[index].row[number] == selectedTable ? Color("primaryButtonColor") : Color(colorNames[number]))
                                    .animation(.default, value: tableList[index].row[number] == selectedTable)
                                    .clipShape(.buttonBorder)
                                
                            }
    
                        }
                    }
                }
            }  .padding()
            
            Spacer()
            Spacer()
            Button {
                generateQuestions()
            }label: {
                Text("Start Practice")
                    .font(.headline)
                    .padding()
                    .background(Color("primaryButtonColor"))
                    .foregroundColor(Color("primaryTextColor"))
                    .clipShape(.buttonBorder)
            }.accentColor(.blue)
        }
        
    }
    
    func generateQuestions()  {
        var generatedQuestions : [Question] = []
        for _ in 1...numberOfQuestion {
            let multiplier  = Int.random(in: 1...12)
            let correctAnswer = selectedTable * multiplier
            let isPlaceholderRandom = Bool.random()
            let qusetionFormatOne = "\(selectedTable) x ? = \(correctAnswer)"
            let qusetionFormatTwo = "\(selectedTable) x \(multiplier) = ?"
            generatedQuestions.append(Question(
                questionText: isPlaceholderRandom ? qusetionFormatOne : qusetionFormatTwo,
                correctAnswer:isPlaceholderRandom ? multiplier : correctAnswer)
            )
        }
        questions = generatedQuestions
    }
}

#Preview {
    SettingsView(
        numberOfQuestion: .constant(10),
        questions: .constant([
            Question(questionText: "2 x ? = 8", correctAnswer: 4),
            Question(questionText: "3 x 5 = ?", correctAnswer: 15),
            Question(questionText: "7 x ? = 49", correctAnswer: 7),
            Question(questionText: "5 x 6 = ?", correctAnswer: 30)
        ])
    )
}
