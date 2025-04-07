//
//  Untitled.swift
//  GOPeat
//
//  Created by Oxa Marvel on 02/04/25.
//

import SwiftUI
import SwiftData

class TenantSearchViewModel: ObservableObject{
    @Published var searchTerm: String = ""
    @Published var sheeHeight: PresentationDetent = .fraction(0.1)
    @Published var selectedCategories: [String] = []
    @Published var filteredTenants: [Tenant] = []
    
    let tenants: [Tenant]
    let categories: [String] = ["Halal", "Non-Halal"] + FoodCategory.allCases.map{ $0.rawValue }
    
    init(tenants: [Tenant]) {
        self.tenants = tenants
        self.filteredTenants = tenants
    }
    func doSearch(searchTerm: String) -> [Tenant] {
        let loweredCaseString = searchTerm.lowercased()
        let foodCategories = selectedCategories.filter{$0 != "Halal" && $0 != "Non-Halal"}
        return filteredTenants.filter { tenant in
            //Search by tenant name
            tenant.name.lowercased().contains(loweredCaseString) ||
            //Search by food name while considering filters
            tenant.foods.filter{food in
                Set(foodCategories).isSubset(of: Set(food.categories.map {$0.rawValue}))
            }.contains { food in
                food.name.lowercased().contains(loweredCaseString)
            }
        }
    }
    
     func updateFilteredTenant() {
        //Filter Tenant by Halal / Non-Halal
        let containsHalal = selectedCategories.contains("Halal")
        let containsNonHalal = selectedCategories.contains("Non-Halal")
        
        var halalTenants = tenants
        
        if containsHalal {
            halalTenants = halalTenants.filter{$0.isHalal == true}
        }
        if containsNonHalal{
            halalTenants = halalTenants.filter{$0.isHalal == false}
        }
        
        let foodCategories = selectedCategories.filter{$0 != "Halal" && $0 != "Non-Halal"}
        
        if foodCategories.isEmpty {
            filteredTenants = halalTenants
        } else {
            //Filter by foodCategories
            filteredTenants = halalTenants.filter{ tenant in
                return tenant.foods.contains { food in
                    Set(foodCategories).isSubset(of: Set(food.categories.map {$0.rawValue}))
                }
            }
        }
    }
    
    func onClose() {
        sheeHeight = .fraction(0.1)
        searchTerm = ""
        selectedCategories = []
        filteredTenants = tenants
    }
}

struct ModalSearchComponent: View {
    @FocusState var isTextFieldFocused: Bool
    private let maxHeight: PresentationDetent = .fraction(1)
    @ObservedObject var tenantSearchViewModel: TenantSearchViewModel
    
    private func showTenant(tenants: [Tenant]) -> some View {
           VStack(alignment: .leading) {
               Text("Tenants")
                   .font(.headline)
                   .fontWeight(.bold)
                   .padding(0)
               Divider()
               ForEach(tenants) {tenant in
                   TenantCard(tenant: tenant)
               }
           }
       }
    
    var body: some View {
        VStack {
            SearchBar(searchTerm: $tenantSearchViewModel.searchTerm, isTextFieldFocused: _isTextFieldFocused ,onCancel: tenantSearchViewModel.onClose)
            ScrollView(.vertical){
                    Filter(categories: tenantSearchViewModel.categories, selectedCategories: $tenantSearchViewModel.selectedCategories)
                    .onChange(of: tenantSearchViewModel.selectedCategories) { _, _ in
                        tenantSearchViewModel.updateFilteredTenant()
                }
                if (tenantSearchViewModel.sheeHeight ==  .fraction(1) || tenantSearchViewModel.sheeHeight ==  .fraction(0.7)) {
                    VStack {
                        if tenantSearchViewModel.searchTerm.isEmpty {
                            showTenant(tenants: tenantSearchViewModel.filteredTenants)
                        } else {
                            showTenant(tenants: tenantSearchViewModel.doSearch(searchTerm: tenantSearchViewModel.searchTerm))
                        }
                    }
                }

            }
        }
        .padding()
        .presentationDetents([.fraction(0.1), .fraction(0.7), .fraction(1)], selection: $tenantSearchViewModel.sheeHeight)
        .interactiveDismissDisabled()
        .presentationBackgroundInteraction(.enabled(upThrough: maxHeight))
        .onChange(of: isTextFieldFocused, initial: false) { _, newValue in
            withAnimation {
                tenantSearchViewModel.sheeHeight = newValue ? .fraction(0.7) : .fraction(0.1)
            }
        }
        .onChange(of: tenantSearchViewModel.sheeHeight) { _, newValue in
            if newValue == .fraction(0.1) {
                isTextFieldFocused = false
                tenantSearchViewModel.onClose()
            }
        }

    }
}
