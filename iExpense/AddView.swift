//
//  AddView.swift
//  iExpense
//
//  Created by Philip Janzel Paradeza on 2023-08-20.
//

import SwiftUI

struct AddView: View {
    @State private var name = "Expense Name"
    @State private var type = "Personal"
    @State private var amount = 0.0
    @State private var currencyCode = "USD"
    @ObservedObject var expenses: Expenses
    @Environment(\.dismiss) var dismiss
    
    let types = ["Business", "Personal"]
    var body: some View {
        NavigationView{
            VStack{
                Form{
                    Picker("Type", selection: $type){
                        ForEach(types, id: \.self){
                            Text($0)
                        }
                    }
                    TextField("Amount", value: $amount, format: .currency(code: "")).keyboardType(.decimalPad)
                    Picker("Currency", selection: $currencyCode){
                        ForEach(Locale.commonISOCurrencyCodes, id: \.self){
                            Text($0)
                        }
                    }
                }
                .navigationTitle($name)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    Button("Save"){
                        let item = ExpenseItem(name: name, type: type, amount: amount, currencyCode: currencyCode)
                        expenses.items.append(item)
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
