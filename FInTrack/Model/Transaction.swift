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
            return Color("Primary")
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
    
    
    init(title: String, amount: Float, notes: String, date: Date, type: TransactionType, category: Category? = nil) {
        self.title = title
        self.amount = amount
        self.notes = notes
        self.date = date
        self.type = type.rawValue
        self.category = category
    }
}


@Model
class Category {
    @Attribute(.unique) var name: String
    
    init(name: String) {
        self.name = name
    }
}


