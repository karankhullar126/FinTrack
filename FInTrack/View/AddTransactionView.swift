//
//  AddTransactionView.swift
//  FInTrack
//
//  Created by Karan Khullar on 09/10/24.
//

import SwiftUI

struct AddTransactionView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Binding var showAddTransaction: Bool
    @State var amountString: String
    @State var transaction: Transaction
    @State var enableSave: Bool
    @State var selectedCategory: Category?
    @State var showCategory: Bool
    @Environment(\.modelContext) private var modelContext
    
    var isEditing: Bool
    var transactionToEdit: Transaction?
    
    init(showAddTransaction: Binding<Bool>, isEditing: Bool = false, transactionToEdit: Transaction? = nil, enableSave: Bool = false, transaction: Transaction = Transaction()) {
        self._showAddTransaction = showAddTransaction
        self._amountString = State(initialValue: String(transactionToEdit?.amount ?? 0))
        self._transaction = State(initialValue: transaction)
        self._enableSave = State(initialValue: enableSave)
        self._selectedCategory = State(initialValue: transactionToEdit?.category)
        self._showCategory = State(initialValue: (transactionToEdit?.transactionType ?? .expense) == .expense)
        self.isEditing = isEditing
        self.transactionToEdit = transactionToEdit
        
        if let transactionToEdit = transactionToEdit {
            self.transaction.updateRequiredfieldsForEdit(transactionToEdit)
        }
    }
    
    var body: some View {
            VStack {
                // Expense and income segment
                if !isEditing {
                    Picker("", selection: $transaction.type) {
                        Text(UIStrings.expense).tag(TransactionType.expense.rawValue)
                        Text(UIStrings.income).tag(TransactionType.income.rawValue)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: transaction.type) {
                        withAnimation {
                            showCategory = transaction.transactionType == .expense
                        }
                    }
                }
               // All the input fields
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
                    if showCategory {
                        // Category navigation
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
            .navigationTitle(isEditing ? getEditTitle() : UIStrings.addTransaction)
            .navigationBarItems(
                leading: Button(isEditing ? "" : UIStrings.cancel, action: cancelAction)
                    .foregroundColor(Color.primary),
                trailing: Button(UIStrings.save, action: saveAction)
                    .foregroundColor(enableSave ? Color.primary : Color.gray)
                    .disabled(!enableSave))
           
    }
    
    func getEditTitle() -> String {
        transactionToEdit?.transactionType == .expense ? UIStrings.editExpense : UIStrings.editIncome
    }
    
    func cancelAction() {
        self.showAddTransaction = false
    }
    
    func saveAction() {
        if isEditing {
            self.transactionToEdit?.updateRequiredfieldsForEdit(transaction)
            self.transactionToEdit?.category = selectedCategory
            dismiss()
        } else {
            if transaction.transactionType == .expense {
                transaction.category = selectedCategory
            }
            modelContext.insert(transaction)
        }
        self.showAddTransaction = false
    }
    
    func validateTransaction() {
        enableSave = (!transaction.title.isEmpty && transaction.amount > 0)
    }
}


struct TransactionTextField: View {
    
    var title: String
    @Binding var inputText: String
    @State var showtitle: Bool
    var isTextEditor: Bool = false
    
    @FocusState private var isFocused: Bool
    
    init(title: String, inputText: Binding<String>, isTextEditor: Bool = false) {
        self.title = title
        self._inputText = inputText
        self.showtitle = isTextEditor
        self.isTextEditor = isTextEditor
        self.isFocused = isFocused
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if showtitle {
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
        }.onChange(of: inputText) {
            withAnimation {
                showtitle = !inputText.isEmpty || isTextEditor
            }
        }
    }
}
