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
    @State var selectedCategory: Category? = nil
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("", selection: $transaction.type) {
                    Text(UIStrings.expense).tag(TransactionType.expense.rawValue)
                    Text(UIStrings.income).tag(TransactionType.income.rawValue)
                }
                .pickerStyle(SegmentedPickerStyle())
               
                ScrollView {
                    TransactionTextField(title: UIStrings.title, inputText: $transaction.title)
                        .padding()
                        .onChange(of: transaction.title, validateTransaction)
                    
                    TransactionTextField(title: UIStrings.amount, inputText: $amountString)
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
                    if transaction.transactionType == .expense {
                        NavigationLink(destination: CategoryListView(selectedCategory: $selectedCategory)) {
                            HStack {
                                Text(UIStrings.category)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.black)
                                Spacer()
                                Text(selectedCategory?.name ?? "None")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color
                                        .gray)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color.primary)
                            }
                            .padding()
                        }
                    }
                    
                    DatePicker(UIStrings.date, selection: $transaction.date, displayedComponents: .date)
                        .padding()
                        .font(.system(size: 14))
                    
                    TransactionTextField(title: UIStrings.notes, inputText: $transaction.notes, isTextEditor: true)
                        .padding()
                    
                    Spacer()
                }
                
            }
            .padding()
            .frame(alignment: .top)
            .navigationTitle(UIStrings.addTransaction)
            .navigationBarItems(
                leading: Button(UIStrings.cancel, action: cancelAction)
                    .foregroundColor(Color.primary),
                trailing: Button(UIStrings.save, action: saveAction)
                    .foregroundColor(enableSave ? Color.primary : Color.gray)
                    .disabled(!enableSave))
           
        }
    }
    
    func cancelAction() {
        self.showAddTransaction = false
    }
    
    func saveAction() {
        if transaction.transactionType == .expense {
            transaction.category = selectedCategory
        }
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
                    .foregroundColor(isFocused ? Color.primary : Color.gray)
            }
            ZStack(alignment: .bottom) {
                if isTextEditor {
                    TextEditor(text: $inputText)
                        .padding(.bottom,10)
                        .frame(maxHeight: 80)
                        .focused($isFocused)
                        .font(.system(size: 14))
                } else {
                    TextField(title, text: $inputText)
                        .padding(.bottom,10)
                        .focused($isFocused) // Bind the focus state
                        .textFieldStyle(PlainTextFieldStyle()) // Remove default styling
                        .background(Color.clear) // Clear background
                        .font(.system(size: 14))
                }
                
                // Underline
                Capsule()
                    .fill(isFocused ? Color.primary : Color.gray) // Change color based on focus
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
