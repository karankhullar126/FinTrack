//
//  AddTransactionView.swift
//  FInTrack
//
//  Created by Karan Khullar on 09/10/24.
//

import SwiftUI

struct AddTransactionView: View {
    
    @Binding var showAddTransaction: Bool
    @State var amountString: String = ""
    @State var transaction = Transaction(title: "", amount: 0, notes: "", date: Date(), type: .expense)
    @State var showDatePickerView: Bool = false
    @State var enableSave: Bool = false
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Select an option", selection: $transaction.type) {
                    Text(UIStrings.expense).tag(TransactionType.expense.rawValue)
                    Text(UIStrings.income).tag(TransactionType.income.rawValue)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                TransactionTextField(title: "Title", inputText: $transaction.title)
                    .padding()
                    .onChange(of: transaction.title, validateTransaction)
                
                TransactionTextField(title: "Amount", inputText: $amountString)
                    .padding()
                    .keyboardType(.decimalPad)
                    .onChange(of: amountString, {
                        if let value = Float(amountString) {
                            transaction.amount = value
                        } else if amountString.isEmpty {
                            transaction.amount = 0.0 // Reset to zero if the field is empty
                        }
                        validateTransaction()
                    })
                
                DatePicker("Date", selection: $transaction.date, displayedComponents: .date)
                    .padding()
                
                TransactionTextField(title: "Notes", inputText: $transaction.notes, isTextEditor: true)
                    .padding()
                
                Spacer()
                
            }
            .frame(alignment: .top)
            .navigationTitle("Add Transaction")
            .navigationBarItems(
                leading: Button("Cancel", action: cancelAction)
                    .foregroundColor(Color("Primary")),
                trailing: Button("Save", action: saveAction)
                    .foregroundColor(enableSave ? Color("Primary") : Color.gray)
                    .disabled(!enableSave))
           
        }
        
        .padding()
    }
    
    func cancelAction() {
        self.showAddTransaction = false
    }
    
    func saveAction() {
        modelContext.insert(transaction)
        self.showAddTransaction = false
    }
    
    func validateTransaction() {
        enableSave = (!transaction.title.isEmpty && transaction.amount > 0)
    }
}


struct TransactionTextField: View {
    
    var title: String
    @Binding var inputText: String
    var isTextEditor: Bool = false
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            if !inputText.isEmpty || isTextEditor {
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(isFocused ? Color("Primary") : Color.gray)
            }
            ZStack(alignment: .bottom) {
                if isTextEditor {
                    TextEditor(text: $inputText)
                        .padding(.bottom,10)
                        .frame(maxHeight: 80)
                        .focused($isFocused)
                } else {
                    TextField(title, text: $inputText)
                        .padding(.bottom,10)
                        .focused($isFocused) // Bind the focus state
                        .textFieldStyle(PlainTextFieldStyle()) // Remove default styling
                        .background(Color.clear) // Clear background
                }
                
                // Underline
                Capsule()
                    .fill(isFocused ? Color("Primary") : Color.gray) // Change color based on focus
                    .frame(height: 2) // Height of the underline
                    .padding(.top, 35) // Position it below the TextField
                    .animation(.easeInOut, value: isFocused) // Animate changes
            }
        }
    }
}

#Preview {
    AddTransactionView(showAddTransaction: .constant(true))
}
