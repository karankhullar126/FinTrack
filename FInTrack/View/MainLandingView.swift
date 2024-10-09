//
//  MainLandingView.swift
//  FInTrack
//
//  Created by Karan Khullar on 07/10/24.
//

import SwiftUI
import SwiftData

struct MainLandingView: View {
    
    @Environment(\.modelContext) private var modelContext
    @State private var totalIncome: Float = 0
    @State private var totalExpense: Float = 0
    @State private var isTransactionEmpty: Bool = true
    @State private var selectedMonth: Int = Date().month
    @State private var selectedYear: Int = Date().year
    @State private var isDatePcikerPresented: Bool = false
    @State private var showAddTransaction: Bool = false
    
    
    var body: some View {
        NavigationSplitView {
            VStack {
                // Month selector
                HStack(alignment: .center) {
                    
                    Spacer()
                    Button(action: changeMonth) {
                        Text(Date.monthString(from: selectedMonth) + " \(selectedYear)")
                            .foregroundColor(.black)
                        Image(systemName: "chevron.down.square.fill")
                            .foregroundColor(Color("Primary"))
                    }.sheet(isPresented: $isDatePcikerPresented) {
                        MonthYearPickerView(isPresented: $isDatePcikerPresented, selectedMonth: $selectedMonth, selectedYear: $selectedYear)
                            .presentationDetents([.medium])
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 45)
                
                Divider()
                // Transaction List
                if let dates = Date.getStartAndEndDates(year: selectedYear, month: selectedMonth) {
                    TransactionList(startDate: dates.startDate, endDate: dates.endDate)
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Image(systemName: "plus")
                            .foregroundColor(Color("Primary"))
                    }
                    .fullScreenCover(isPresented: $showAddTransaction) {
                        AddTransactionView(showAddTransaction: $showAddTransaction)
                    }
                }
            }
            .navigationTitle(UIStrings.welcomeTitle)
        } detail: {
            Text(UIStrings.selectTransaction)
        }
    }
    
    
    private func addItem() {
        self.showAddTransaction = true
//        let category = (try? modelContext.fetch(FetchDescriptor<Category>()).first) ?? Category(name: "Car")
//        let transaction = Transaction(title: "New 100", amount: 200.5, notes: "Car petrol at sector 37", date: Date(), type: .income)
//        
//        modelContext.insert(category)
//        modelContext.insert(transaction)
//        do {
//            try modelContext.save()
//        } catch {
//            print("Error", error.localizedDescription)
//        }
        
    }
    
    private func changeMonth() {
        isDatePcikerPresented = true
    }
    
}

struct PlaceHolder: View {
    var text: String
    var body: some View {
        VStack {
            Spacer()
            Text(text)
                .frame(maxWidth: .infinity)
                .foregroundColor(.gray)
            Spacer()
        }
    }
}

struct TotalAmoutView: View {
    var totalIncome: Float
    var totalExpense: Float
    var totalAmount: Float
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            VStack(alignment: .center) {
                Text(UIStrings.totalIncome)
                    .font(.system(size: 14))
                Text(totalIncome.formatted())
                    .font(.system(size: 14))
                    .foregroundColor(TransactionType.income.getColour())
                
            }
            Spacer()
            VStack(alignment: .center) {
                Text(UIStrings.totalExpense)
                    .font(.system(size: 14))
                Text(totalExpense.formatted())
                    .font(.system(size: 14))
                    .foregroundColor(TransactionType.expense.getColour())
            }
            Spacer()
            VStack(alignment: .center) {
                Text(UIStrings.totalAmount)
                    .font(.system(size: 14))
                Text(totalAmount.formatted())
                    .font(.system(size: 14))
                    .foregroundColor(totalAmount > 0 ? TransactionType.income.getColour() : TransactionType.expense.getColour())
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 45)
    }
    
}

struct TransactionList: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var transactions: [Transaction]
    
    @State var totalIncome: Float = 0
    @State var totalExpense: Float = 0
    private var totalAmount: Float {
        totalIncome - totalExpense
    }
    
    init(startDate: Date, endDate: Date) {
        let descriptor = FetchDescriptor<Transaction>(
            predicate: #Predicate { $0.date >= startDate && $0.date <= endDate  },
            sortBy: [
                .init(\.date, order: .reverse)
            ]
        )
        _transactions = Query(descriptor)
    }
    
    var body: some View {
        VStack {
            // Total Amount view
            TotalAmoutView(totalIncome: totalIncome, totalExpense: totalExpense, totalAmount: totalAmount)
            Divider()
            if transactions.isEmpty {
                //Placeholder
                PlaceHolder(text: UIStrings.noTransactions)
            } else {
                // List of transactions
                List {
                    ForEach(transactions) { transaction in
                        TransactionCell(transaction: transaction)
                    }
                }.listStyle(PlainListStyle())
            }
        }
        .onAppear(perform: updateTransactionTotal)
        .onChange(of: transactions, updateTransactionTotal)
            
    }
    
    private func updateTransactionTotal() {
        totalIncome = 0
        totalExpense = 0
        transactions.forEach { transaction in
            if transaction.transactionType == .income {
                totalIncome += transaction.amount
            } else {
                totalExpense += transaction.amount
            }
        }
    }
}

#Preview {
    MainLandingView()
}
