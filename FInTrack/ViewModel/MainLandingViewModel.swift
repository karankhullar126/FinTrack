//
//  MainLandingViewModel.swift
//  FInTrack
//
//  Created by Karan Khullar on 08/10/24.
//

import Foundation
import SwiftData
import SwiftUI

class MainLandingViewModel: ObservableObject {
    
    private var modelContext: ModelContext
    @Query var transactions: [Transaction] = []
    var totalExpense: Float = 0
    var totalIncome: Float = 0
    
    var total: Float {
        totalIncome - totalExpense
    }
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
//        self.transactions = (try? modelContext.fetch(FetchDescriptor<Transaction>())) ?? []
    }
    
    
    
}
