//
//  AddView.swift
//  Expenses
//
//  Created by Софья П. Рожина on 30/10/2019.
//  Copyright © 2019 Софья П. Рожина. All rights reserved.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var expenses: Expenses
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    
    @State private var showingErrorAlert = false
    @State private var alertMessage = ""
    
    static let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name:", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(trailing: Button("Save") {
                self.save()
            })
            .alert(isPresented: $showingErrorAlert) {
                Alert(title: Text("Validation error"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func save() {
        guard !name.isEmpty else {
            alertMessage = "Name is empty"
            showingErrorAlert = true
            return
        }
        
        guard let actualAmount = Double(self.amount) else {
            alertMessage = "Amount is not correct"
            showingErrorAlert = true
            return
        }
        let item = ExpenseItem(id: UUID(),
                               name: self.name,
                               type: self.type,
                               amount: actualAmount)
        self.expenses.items.append(item)
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
