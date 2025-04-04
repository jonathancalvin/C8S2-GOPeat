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
    @Binding var maxPrice: Double
    @Binding var isOpenNow: Bool
    
    @State var showPriceFilter: Bool = false
    
    // Function to return conflicting category
    private func conflictingCategory(for category: String) -> String? {
        if category.hasPrefix("Non-") {
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
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                Button {
                    showPriceFilter = true
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                        .foregroundStyle(Color("Primary"))
                }
                .sheet(isPresented: $showPriceFilter) {
                    MoreFilterView(maxPrice: $maxPrice, isOpenNow: $isOpenNow)
                }
                
                ForEach(categories, id: \.self) { category in
                    Button {
                        if !selectedCategories.contains(category) {
                            // Check conflicting category
                            if let conflictCategory = conflictingCategory(for: category) {
                                selectedCategories.removeAll { $0 == conflictCategory }
                            }
                            selectedCategories.append(category)
                        } else {
                            selectedCategories.removeAll { $0 == category }
                        }
                    } label: {
                        Text(category)
                            .font(.caption)
                    }
                    .foregroundStyle(selectedCategories.contains(category) ? Color("Secondary")  :  Color.primary)
                    .padding(10)
                    .background(selectedCategories.contains(category) ? Color.blue : Color(.systemGray5))
                    .clipShape(Capsule())
                }
            }
        }
        .padding()
    }
}

struct MoreFilterView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var maxPrice: Double
    @Binding var isOpenNow: Bool
    
    @State var tempMaxPrice: Double = 100000
    @State var tempIsOpenNow: Bool = false
    
    private func onApply(){
        maxPrice = tempMaxPrice
        isOpenNow = tempIsOpenNow
        dismiss()
    }
    private func onClear(){
        maxPrice = 100000
        isOpenNow = false
        dismiss()
    }
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    Text("Filter Restaurant")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.vertical, 20)

                    Text("Price Range")
                        .font(.subheadline)
                        .fontWeight(.bold)

                    Text("Max Price: Rp.\(tempMaxPrice, specifier: "%.0f")")
                        .font(.caption)
                    Slider(value: $tempMaxPrice, in: 0...100000, step: 1000)
                    
                    Text("Availability Status")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                    Button {
                        tempIsOpenNow.toggle()
                    } label: {
                        Text("Open Now")
                            .font(.caption)
                    }
                    .foregroundStyle(tempIsOpenNow ? Color("Secondary") : Color("Primary"))
                    .padding(10)
                    .background(tempIsOpenNow ? Color.blue : Color(.systemGray5))
                    .clipShape(Capsule())
                }
            }
            VStack {
                Spacer()
                
                HStack {
                    Button {
                        onClear()
                    } label: {
                        Text("Clear Filter")
                            .foregroundStyle((tempMaxPrice != 100000 || tempIsOpenNow) ? Color.red : Color.gray)
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke((tempMaxPrice != 100000 || tempIsOpenNow) ? Color.red : Color.gray, lineWidth: 1)
                            )
                    }
                    .disabled(tempMaxPrice == 100000 && !tempIsOpenNow)
                    
                    Button {
                        onApply()
                    } label: {
                        Text("Apply")
                            .foregroundStyle(Color("Secondary"))
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .clipShape(Capsule())
                    }
                }
                .frame(maxWidth: .infinity)
                .shadow(radius: 5)
            }
            .frame(maxWidth: .infinity)
        }
        .onAppear {
            tempMaxPrice = maxPrice
            tempIsOpenNow = isOpenNow
        }
        .padding()
        .presentationDragIndicator(.visible)
    }
}
