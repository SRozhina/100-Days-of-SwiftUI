//
//  ContentView.swift
//  RockScissorsPaper
//
//  Created by Софья Рожина on 18.10.2019.
//  Copyright © 2019 Софья Рожина. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var appsChoice = Value.allCases.randomElement() ?? .rock
    @State private var shouldWin = Bool.random()
    @State private var score = 0
    @State private var showingAlert = false
    @State var roundsCount = 1
    
    private enum Value: String, CaseIterable {
        case rock
        case scissors
        case paper
    }
    
    private let values = Value.allCases
    
    
    var body: some View {
        VStack {
            Spacer()
            Text("App's move:")
                .font(.title)
            Text(appsChoice.rawValue.capitalized)
                .font(.callout)
                .padding()
            
            Spacer()
            Text("Game result:")
                .font(.title)
            Text(shouldWin ? "Win" : "Lose")
                .font(.callout)
                .padding()
            
            Spacer()
            HStack {
                ForEach(0..<values.count) { index in
                    Button("\(self.values[index].rawValue.capitalized)") {
                        self.handleUserChoice(self.values[index])
                    }
                    .padding()
                }
            }
            Spacer()
        }.alert(isPresented: $showingAlert) {
            Alert(title: Text("Game over"),
                  message: Text("Your score is \(score)"),
                  dismissButton: .default(Text("Continue")) {
                    self.startNewGame()
            })
        }
    }
    
    private func handleUserChoice(_ userChoice: Value) {
        let isWin =
            userChoice == .rock && shouldWin && appsChoice == .scissors ||
            userChoice == .paper && shouldWin && appsChoice == .rock ||
            userChoice == .scissors && shouldWin && appsChoice == .paper ||
            userChoice == .rock && !shouldWin && appsChoice == .paper ||
            userChoice == .paper && !shouldWin && appsChoice == .scissors ||
            userChoice == .scissors && !shouldWin && appsChoice == .rock
        self.score += isWin ? 1 : 0
        
        roundsCount == 10
            ? showingAlert = true
            : startNewRound()
    }
    
    private func startNewGame() {
        startNewRound()
        score = 0
        roundsCount = 0
    }
    
    private func startNewRound() {
        roundsCount += 1
        appsChoice = Value.allCases.randomElement() ?? .rock
        shouldWin = Bool.random()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
