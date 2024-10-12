//
//  CategoryListView.swift
//  FInTrack
//
//  Created by Karan Khullar on 10/10/24.
//

import SwiftUI
import SwiftData

struct CategoryListView: View {
    
    @Query var categories: [Category]
    @Binding var selectedTransaction: Transaction
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
            VStack {
                if categories.isEmpty {
                    VStack(alignment: .center, spacing: 8) {
                        Text(UIStrings.categoriesPlaceholder)
                            .font(.system(size: 14))
                        Button(action: addItem) {
                            Text(UIStrings.addCategory)
                                .font(.system(size: 14))
                                .foregroundColor(Color.primary)
                        }
                    }.frame(maxWidth: .infinity)
                } else {
                    List {
                        ForEach(categories) { category in
                            HStack {
                                Text(category.name)
                                    .font(.system(size: 14))
                                    .padding()
                                Spacer()
                                if selectedTransaction.category === category {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(Color.primary)
                                }
                            }
                            .background(Color(uiColor: UIColor.systemBackground))
                            .onTapGesture {
                                selectedTransaction.category = category
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }.listStyle(PlainListStyle())
                }
            }.toolbar {
                ToolbarItem {
                    if !categories.isEmpty {
                        Button(action: addItem) {
                            Image(systemName: "plus")
                                .foregroundColor(Color.primary)
                        }
                    }
                }
            }
            .navigationTitle(UIStrings.category)
    }
    
    private func addItem() {
        
    }
}

