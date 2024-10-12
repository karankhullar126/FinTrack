//
//  AddCategoryView.swift
//  FInTrack
//
//  Created by Karan Khullar on 12/10/24.
//

import SwiftUI
import SwiftData

struct AddCategoryView: View {
    
    @State var categoryName: String = ""
    @State var enableSave: Bool = false
    @State var showError: Bool = false
    @Binding var showAddCategory: Bool
    @Environment(\.modelContext) private var modelContext
    @Query var categories: [Category]
    

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                TransactionTextField(title: UIStrings.categoryName, inputText: $categoryName)
                    .onChange(of: categoryName, validateCategory)
                    .padding()
                if showError {
                    Text(UIStrings.categoryError)
                        .font(.system(size: 14))
                        .foregroundColor(Color.red)
                        .padding([.leading, .trailing])
                }
                Spacer()
            }.navigationTitle(UIStrings.addCategoryTitle)
                .navigationBarItems(
                    leading: Button(UIStrings.cancel, action: cancelAction)
                        .foregroundColor(Color.primary),
                    trailing: Button(UIStrings.save, action: saveAction)
                        .foregroundColor(enableSave ? Color.primary : Color.gray)
                        .disabled(!enableSave))
        }
    }
    
    func cancelAction() {
        self.showAddCategory = false
    }
    
    func saveAction() {
        self.showAddCategory = false
        let category = Category(name: categoryName)
        modelContext.insert(category)
    }
    
    func validateCategory() {
        withAnimation {
            let categoryAlreadyExist = categories.contains(where: { category in category.name == categoryName })
            enableSave = !categoryName.isEmpty && !categoryAlreadyExist
            showError = categoryAlreadyExist
        }
        
    }
}


