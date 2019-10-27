//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Софья Рожина on 14.10.2019.
//  Copyright © 2019 Софья Рожина. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    @State private var animationAmount = 0.0
    @State private var isCorrect = true
    @State private var answered = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]),
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0..<3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        FlagImage(image: Image(self.countries[number]))
                    }
                        .rotation3DEffect(.degrees(self.animationAmount), axis: (x: 0, y: 1, z: 0))
                        .opacity(self.answered && self.isCorrect && number != self.correctAnswer || !self.isCorrect ? 0.25 : 1)
                        .animation(self.answered && self.isCorrect && number == self.correctAnswer ? .default : nil)
                }
                Spacer()
                Text("Your score is \(score)")
                    .foregroundColor(.white)
                    .font(.title)
            }
        }.alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle),
                  message: Text("Your score is \(score)"),
                  dismissButton: .default(Text("Continue")) {
                    self.askQuestion()
                })
        }
    }
    
    private func flagTapped(_ number: Int) {
        answered = true
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            animationAmount += 360
        } else {
            scoreTitle = "Wrong! This is a flag of \(countries[number])"
            isCorrect = false
        }
        
        showingScore = true
    }
    
    private func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        isCorrect = true
        answered = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct FlagImage: View {
    var image: Image
    
    var body: some View {
        image
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}
