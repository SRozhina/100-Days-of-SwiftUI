//
//  ContentView.swift
//  BetterRest
//
//  Created by Софья Рожина on 21.10.2019.
//  Copyright © 2019 Софья Рожина. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultBedtime
    @State private var coffeeAmount = 1
    
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @State private var showingAlert = false
    
    private static  var defaultBedtime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    private var sleepTime: String {
        let model = SleepCalculator()

        let components = Calendar.current.dateComponents([.hour, .minute],
                                                         from: wakeUp)
        let hours = (components.hour ?? 0) * 60 * 60
        let minutes = (components.minute ?? 0) * 60

        let sleepDate: Date
        if let prediction = try? model.prediction(wake: (Double(hours + minutes)),
                                                  estimatedSleep: sleepAmount,
                                                  coffee: Double(coffeeAmount))  {
            sleepDate = wakeUp - prediction.actualSleep
        } else {
            sleepDate = Date()
        }

        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: sleepDate)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When do you want to wake up?")) {
                    DatePicker("Please enter a date", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                
                Section(header: Text("Desire amount of sleep")) {
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                Section(header: Text("Dayly coffee intake:")) {
                    Picker("Coffee amount", selection: $coffeeAmount) {
                        ForEach(0..<20) { index in
                            if index == 1 {
                                Text("1 cup")
                            } else {
                                Text("\(index) cups")
                            }
                        }
                    }.pickerStyle(WheelPickerStyle())
                }
                
                Section(header: Text("Your ideal bedtime is...")) {
                    Text(sleepTime)
                        .font(.title)
                }
            }
            .navigationBarTitle("BetterRest")
            .navigationBarItems(trailing: Button(action: calculateBedtime) {
                Text("Calculate")
            })
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(alertTitle),
                          message: Text(alertMessage),
                          dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func calculateBedtime() {
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute],
                                                         from: wakeUp)
        let hours = (components.hour ?? 0) * 60 * 60
        let minutes = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: (Double(hours + minutes)),
                                                  estimatedSleep: sleepAmount,
                                                  coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            alertMessage = formatter.string(from: sleepTime)
            alertTitle = "Your ideal bedtime is..."
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
