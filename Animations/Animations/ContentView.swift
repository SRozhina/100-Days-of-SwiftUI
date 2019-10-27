//
//  ContentView.swift
//  Animations
//
//  Created by Софья Рожина on 27.10.2019.
//  Copyright © 2019 Софья Рожина. All rights reserved.
//

import SwiftUI

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}

struct ContentView: View {
    @State private var animationAmount1: CGFloat = 1
    @State private var animationAmount2: CGFloat = 1
    @State private var animationAmount3 = 0.0
    @State private var enabled = false
    
    let letters = Array("Hello SwiftUI!")
    @State private var enabled1 = false
    @State private var dragAmount = CGSize.zero
    
    @State private var isShowingRed = false
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Tap me") { }
                .padding(50)
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.red)
                        .scaleEffect(animationAmount1)
                        .opacity(Double(2 - animationAmount1))
                        .animation(
                            Animation.easeInOut(duration: 1)
                                .repeatForever(autoreverses: false)
                    )
            )
                .onAppear {
                    self.animationAmount1 = 2
            }
                        
            Stepper("Scale amount", value: $animationAmount2.animation(), in: 1...10)

            Button("Tap Me") {
                self.animationAmount2 += 1
            }
            .padding(40)
            .background(Color.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .scaleEffect(animationAmount2)
            
            Button("Tap me") {
                withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
                    self.animationAmount3 += 360
                }
            }
                .padding(50)
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(Circle())
                .rotation3DEffect(.degrees(animationAmount3),
                                  axis: (x: 0, y: 1, z: 0))
                        
            Button("Tap me") {
                self.enabled.toggle()
            }
            .frame(width: 200, height: 200)
            .background(enabled ? Color.blue : Color.red)
            .foregroundColor(.white)
            .animation(.default)
            .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
            .animation(.interpolatingSpring(stiffness: 10, damping: 1))
            
            HStack(spacing:0) {
                ForEach(0..<letters.count) { num in
                    Text(String(self.letters[num]))
                        .padding(5)
                        .font(.title)
                        .background(self.enabled1 ? Color.blue : Color.red)
                        .offset(self.dragAmount)
                        .animation(Animation.default.delay(Double(num) / 20))
                }
            }.gesture(
                DragGesture()
                    .onChanged { self.dragAmount = $0.translation }
                    .onEnded { _ in
                        self.dragAmount = .zero
                        self.enabled1.toggle()
                    }
            )
            
            VStack {
                Button("Tap me") {
                    withAnimation {
                        self.isShowingRed.toggle()
                    }
                }
                
                if isShowingRed {
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: 200, height: 200)
                        .transition(.pivot)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
