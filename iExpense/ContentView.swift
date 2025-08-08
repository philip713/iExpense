//
//  ContentView.swift
//  iExpense
//
//  Created by Philip Janzel Paradeza on 2023-05-01.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
    let currencyCode: String
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet{
            if let encoded = try? JSONEncoder().encode(items){
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init(){
        if let savedItems = UserDefaults.standard.data(forKey: "Items"){
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems){
                items = decodedItems
                return
            }
        }
        items = []
    }
    
    var personalItems: [ExpenseItem]{
        items.filter{$0.type == "Personal"}
    }
    var businessItems: [ExpenseItem]{
        items.filter{$0.type == "Business"}
    }
}
struct ContentView: View {

    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false
    var body: some View {
        NavigationStack{
            List{
                Section("Personal"){
                    ForEach(expenses.personalItems) { item in
                        HStack{
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }
                            Spacer()
                            Text(item.amount, format: .currency(code: item.currencyCode))
                        }
                        .foregroundColor(item.amount >= 100 ? .red : item.amount < 10 ? .green : .blue)
                        .accessibilityLabel("\(item.name) amount: \(item.amount) \(item.currencyCode)")
                        .accessibilityHint(Text("Personal Expense"))
                    }
                    .onDelete(perform: removePersonal)
                }
                Section("Business"){
                    ForEach(expenses.businessItems) { item in
                        HStack{
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }
                            Spacer()
                            Text(item.amount, format: .currency(code: item.currencyCode))
                        }
                        .foregroundColor(item.amount >= 100 ? .red : item.amount < 10 ? .green : .blue)
                    }
                    .onDelete(perform: removeBusiness)
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
//                Button {
//                    showingAddExpense = true
//                } label: {
//                    Image(systemName: "plus")
//                }
                NavigationLink ("Add"){
                    AddView(expenses: expenses)
                }
            }
//            .sheet(isPresented: $showingAddExpense) {
//                AddView(expenses: expenses)
//            }
        }
    }
    func removeItems(at offsets: IndexSet){
        expenses.items.remove(atOffsets: offsets)
    }
    
    func removePersonal(at offsets: IndexSet){
        let id = expenses.personalItems[offsets.first!].id
        expenses.items.removeAll(where: {$0.id == id})
    }
    func removeBusiness(at offsets: IndexSet){
        let id = expenses.businessItems[offsets.first!].id
        expenses.items.removeAll(where: {$0.id == id})
    }
}

struct SecondView: View {
    let name: String
    @Environment(\.dismiss) var dismiss
    var body: some View{
        Button("Dismiss"){
            dismiss()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
