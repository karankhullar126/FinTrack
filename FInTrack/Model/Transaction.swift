//
//  Transaction.swift
//  FInTrack
//
//  Created by Karan Khullar on 07/10/24.
//

import Foundation
import SwiftData
import SwiftUI

enum TransactionType: Int, CaseIterable {
    case income = 1, expense = 2
    
    func getColour() -> Color {
        switch self {
        case .income:
            return Color.primary
        case .expense:
            return Color.red
        }
    }
    
    func getValue() -> String {
        switch self {
        case .income:
            return UIStrings.income
        case .expense:
            return UIStrings.expense
        }
    }
}

@Model
class Transaction {
    @Attribute(.unique) var id: UUID = UUID()
    var title: String = ""
    var amount: Float = 0
    var notes: String = ""
    var date: Date = Date()
    var category: Category? = nil
    var type: Int = 1
    
    var transactionType: TransactionType {
        return TransactionType(rawValue: type)!
    }
    
    
    init() {
        self.title = ""
        self.amount = 0
        self.notes = ""
        self.date = Date()
        self.type = TransactionType.expense.rawValue
        self.category = nil
    }
    
    func updateRequiredfieldsForEdit(_ transaction: Transaction) {
        self.title = transaction.title
        self.amount = transaction.amount
        self.notes = transaction.notes
    }
}


@Model
class Category {
    @Attribute(.unique) var name: String
    
    init(name: String) {
        self.name = name
    }
}


