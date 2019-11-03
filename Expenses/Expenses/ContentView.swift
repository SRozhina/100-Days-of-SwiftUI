//
//  ContentView.swift
//  Expenses
//
//  Created by Софья П. Рожина on 30/10/2019.
//  Copyright © 2019 Софья П. Рожина. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { expense in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(expense.name)
                                .font(.headline)
                            Text(expense.type)
                        }
                        
                        Spacer()
                        Text(self.expenseAmountString(from: expense.amount))
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationBarTitle("Expenses")
            .navigationBarItems(trailing:
                Button(action: {
                    self.showingAddExpense = true
                }) {
                    Image(systemName: "plus")
                }
            )
            //.navigationBarItems(leading: EditButton())
        }
        .sheet(isPresented: $showingAddExpense) {
            AddView(expenses: self.expenses)
        }
    }
    
    private func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    private func expenseAmountString(from amount: Double) -> String {
        let format: String
        if amount < 10 {
            format = "%.2f"
        } else if amount < 100 {
            format = "%.1f"
        } else {
            format = "%.f"
        }
        return String(format: "$" + format, amount)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

