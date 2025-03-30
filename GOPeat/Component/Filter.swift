//
//  Filter.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 29/03/25.
//

import SwiftUI

struct Filter: View {
    let categories: [String]
    @Binding var selectedCategories: [String]
    
    // Function to return conflicting category
    func conflictingCategory(for category: String) -> String?{
        if category.hasPrefix("Non-"){
            // If start with "Non-", check category without "Non-"
            let conflictCategory = String(category.dropFirst(4))
            return selectedCategories.contains(conflictCategory) ? conflictCategory : nil
        } else {
            // If start without "Non-", check category with "Non-"
            let conflictCategory = "Non-" + category
            return selectedCategories.contains(conflictCategory) ? conflictCategory : nil
        }
    }

    var body: some View {
        ScrollView(.horizontal){
            HStack(){
                ForEach(categories, id: \.self){ category in
                    Button {
                        if !selectedCategories.contains(category) {
                            // Check conflicting category
                            if let conflictCategory = conflictingCategory(for: category) {
                                selectedCategories.removeAll { $0 == conflictCategory }
                            }
                            selectedCategories.append(category)
                        } else {
                            selectedCategories.removeAll { $0 == category
                            }
                        }
                    } label: {
                        Text(category)
                    }
                    .foregroundStyle(.black)
                    .padding()
                    .background(selectedCategories.contains(category) ? Color.blue : Color(.systemGray5))
                    .clipShape(Capsule())
                    .frame(width: 150)
                }

            }
        }.padding()
    }
}
