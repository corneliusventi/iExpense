//
//  ContentView.swift
//  iExpense
//
//  Created by Cornelius Venti on 05/11/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    let currency = Locale.current.currency?.identifier ?? "USD"
    
    var body: some View {
        NavigationStack {
            List {
                Section("Personal") {
                    if expenses.personalItems.count == 0 {
                        Text("None")
                    } else {
                        ForEach(expenses.personalItems ) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    Text(item.type)
                                }
                                
                                Spacer()
                                
                                Text(item.amount, format: .currency(code: currency))
                                    .foregroundColor(colorExpense(amount: item.amount))
                            }
                        }
                        .onDelete(perform: removePersonalItems)
                    }
                }
                
                Section("Business") {
                    if expenses.businessItems.count == 0 {
                        Text("None")
                    } else {
                        ForEach(expenses.businessItems ) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    Text(item.type)
                                }
                                
                                Spacer()
                                
                                Text(item.amount, format: .currency(code: currency))
                                    .foregroundColor(colorExpense(amount: item.amount))
                            }
                        }
                        .onDelete(perform: removeBusinessItems)
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    
    func removePersonalItems(at offsets: IndexSet) {
        var realOffsets = IndexSet()
        offsets.forEach { offset in
            let item = expenses.personalItems[offset]
            if let index = expenses.items.firstIndex(where: { $0.id == item.id }) {
                realOffsets.insert(index)
            }
        }
        expenses.items.remove(atOffsets: realOffsets)
    }
    
    func removeBusinessItems(at offsets: IndexSet) {
        var realOffsets = IndexSet()
        offsets.forEach { offset in
            let item = expenses.businessItems[offset]
            if let index = expenses.items.firstIndex(where: { $0.id == item.id }) {
                realOffsets.insert(index)
            }
        }
        expenses.items.remove(atOffsets: realOffsets)
    }

    func colorExpense(amount: Double) -> Color {
        if amount <= 10 {
            return Color.blue
        } else if amount <= 100 {
            return Color.yellow
        } else {
            return Color.red
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
