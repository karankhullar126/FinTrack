//
//  TransactionCell.swift
//  FInTrack
//
//  Created by Karan Khullar on 07/10/24.
//

import SwiftUI

struct TransactionCell: View {
    var transaction: Transaction
    
    var body: some View {
        HStack {
            // Date
            VStack {
                VStack {
                    Text("\(transaction.date.dateNumber)")
                        .font(.system(size: 18, weight: .bold))
                    Text(transaction.date.monthString)
                        .font(.system(size: 16, weight: .bold))
                }.padding()
            }
            .background(transaction.transactionType.getColour())
            .cornerRadius(20)
            .opacity(0.7)
            // Title, Category and type
            VStack(alignment: .leading) {
                Text(transaction.title)
                if let category = transaction.category {
                    Text(category.name)
                }
                Text(transaction.transactionType.getValue())
                    .foregroundColor(transaction.transactionType.getColour())
            }
            Spacer()
            // Amount
            Text("\(transaction.amount.formatted())")
                .padding()
        }
    }
}

