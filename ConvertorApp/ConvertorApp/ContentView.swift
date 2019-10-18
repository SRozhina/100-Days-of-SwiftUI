//
//  ContentView.swift
//  ConvertorApp
//
//  Created by Софья Рожина on 13.10.2019.
//  Copyright © 2019 Софья Рожина. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var unitType = 0
    
    @State private var fromUnit = 0
    @State private var toUnit = 1
    @State private var countString = "0"
    @State private var unitsState: [Dimension] = Self.lengthUnits
    
    private static let lengthUnits = [UnitLength.meters,
                                      .kilometers,
                                      .feet,
                                      .yards,
                                      .miles]
    private static let temperatureUnits = [UnitTemperature.celsius,
                                           .fahrenheit,
                                           .kelvin]
    private static let timeUnits = [UnitDuration.milliseconds,
                                    .seconds,
                                    .minutes,
                                    .hours]
    private static let volumeUnits = [UnitVolume.milliliters,
                                      .liters,
                                      .cups,
                                      .pints,
                                      .gallons]
    
    private var allUnits: [(String, [Dimension])] {
        return [("Length", Self.lengthUnits),
                ("Temperature", Self.temperatureUnits),
                ("Time", Self.timeUnits),
                ("Volume", Self.volumeUnits)]
    }
    
    private var units: [Dimension] {
        guard unitType < allUnits.count else { return Self.lengthUnits }
        return allUnits[unitType].1
    }
    
    private var result: Double {
        guard let count = Double(countString),
            fromUnit < units.count - 1,
            toUnit < units.count - 1 else { return 0 }
        let from = units[fromUnit]
        let fromMeasurement = Measurement(value: count, unit: from)
        let to = units[toUnit]
        let toMeasurement = fromMeasurement.converted(to: to)
        return toMeasurement.value
    }
    
    var body: some View {
        let typePickerIndexBinding = Binding<Int>(get: {
            return self.unitType
        }) {
            self.unitType = $0
            self.unitsState = self.units
        }
        
        return NavigationView {
            Form {
                Section(header: Text("Choose units type")) {
                    Picker("Unit type", selection: typePickerIndexBinding) {
                        ForEach(0..<allUnits.count) {
                            Text(self.allUnits[$0].0)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Choose unit to convert from")) {
                    Picker("From Unit", selection: $fromUnit) {
                        ForEach(units, id: \.self) {
                            Text($0.symbol)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Choose unit to convert to")) {
                    Picker("To Unit", selection: $toUnit) {
                        ForEach(units, id: \.self) {
                            Text($0.symbol)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("How much to convert")) {
                    TextField("123", text: $countString)
                }

                Section(header: Text("Result")) {
                    Text("\(result, specifier: "%.2f") \(units[toUnit].symbol)")
                }
            }.navigationBarTitle("Converter")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
