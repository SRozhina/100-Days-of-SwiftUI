//
//  ContentView.swift
//  MultiplicationChallenge
//
//  Created by Софья Рожина on 28.10.2019.
//  Copyright © 2019 Софья Рожина. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    //Presenting
    @State private var isGameInProgress = false
    @State private var showScoreAlert = false

    //Settings
    //TODO2 implement case all
    private var questionsCounts = [5, 10, 20, 30]
    @State private var upToValue = 2
    @State private var questionsIndex = 10

    //Game
    @State private var questions: [Question] = []
    @State private var currentQuestion: Question = Question(multiplier: 0, multiplicant: 0)
    @State private var roundResult = ""
    @State private var score = 0
    
    var body: some View {
        NavigationView {
            if isGameInProgress {
                Group {
                    Form {
                        Section {
                            Text("\(currentQuestion.multiplier) x \(currentQuestion.multiplicant)")
                            TextField("Result", text: $roundResult)
                                .keyboardType(.numberPad)
                        }
                        Section {
                            Button("Answer") {
                                self.startNewRound()
                            }
                        }
                    }
                }
                .alert(isPresented: $showScoreAlert) {
                    Alert(title: Text("Game finished"),
                          message: Text("Your score is \(score) of \(questionsIndex) possible"),
                          dismissButton: Alert.Button.default(Text("New game"),
                                                              action: { self.isGameInProgress = false }))
                }
            } else {
                Group {
                    Form {
                        Section {
                            Stepper(value: $upToValue, in: 1...12) {
                                Text("Up to \(upToValue)")
                            }
                            Picker("How many questions", selection: $questionsIndex) {
                                ForEach(questionsCounts, id: \.self) {
                                    Text("\($0)")
                                }
                            }
                        }
                        Section {
                            Button("Start game") {
                                self.startNewGame()
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func startNewGame() {
        isGameInProgress = true
        roundResult = ""
        score = 0
        questions = (0..<questionsIndex).map { _ in
            Question(multiplier: Int.random(in: 0...upToValue),
                     multiplicant: Int.random(in: 0...upToValue))
        }
        currentQuestion = questions.first  ?? Question(multiplier: 0, multiplicant: 0)
    }
    
    private func startNewRound() {
        score += Int(roundResult) == currentQuestion.answer ? 1 : 0
        questions.removeFirst()
        if questions.isEmpty {
            showScoreAlert = true
        } else {
            questions.shuffle()
            currentQuestion = questions.first ?? Question(multiplier: 0, multiplicant: 0)
            roundResult = ""
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct Question {
    let multiplier: Int
    let multiplicant: Int
    var answer: Int { multiplier * multiplicant }
}
