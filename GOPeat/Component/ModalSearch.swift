import SwiftUI
import SwiftData

struct ModalSearchComponent: View {
    @Binding var searchTerm: String
    @FocusState var isTextFieldFocused: Bool
    @State private var sheetHeight: PresentationDetent = .fraction(0.1)
    @State private var selectedCategories: [String] = []
    private let maxHeight: PresentationDetent = .fraction(1)
    private let categories: [String] = ["Halal", "Non-Halal"] + FoodCategory.allCases.map{ $0.rawValue }
    let tenants: [Tenant]
    @State private var filteredTenant: [Tenant] = []
    private func doSearch(searchTerm: String) -> some View{
        let loweredCaseString = searchTerm.lowercased()
        let result = filteredTenant.filter { tenant in
            tenant.name.lowercased()
                .contains(loweredCaseString) || tenant.foods.contains { food in
                food.name.lowercased().contains(loweredCaseString)
            }
        }
        return showTenant(tenants: result)
    }
    
    private func updateFilteredTenant() {
        
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
            filteredTenant = halalTenants
        } else {
            //Filter by foodCategories
            filteredTenant = halalTenants.filter{ tenant in
                return tenant.foods.contains { food in
                    Set(foodCategories).isSubset(of: Set(food.categories.map {$0.rawValue}))
                }
            }
        }
    }
    
    private func showTenant(tenants: [Tenant]) -> some View {
        VStack{
            ForEach(tenants) {tenant in
                HStack{
                    Image(tenant.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80)
                    VStack{
                        Text(tenant.name)
                        Text(tenant.canteen?.name ?? "")
                    }
                    Spacer()
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack (spacing: 0){
                HStack(spacing: 5) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(searchTerm.isEmpty ? .gray : .blue)

                    TextField("What should I eat today?", text: $searchTerm)
                        .focused($isTextFieldFocused)
                        .textFieldStyle(.plain)
                        .autocorrectionDisabled()
                }
                .padding(10)
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.trailing, 10)
                
                if isTextFieldFocused{
                    Button(action: {
                        searchTerm = ""
                        isTextFieldFocused = false
                        sheetHeight = .fraction(0.1)
                    }) {
                        Text("Cancel")
                    }
                }
            }.padding(.top, 10)
            ScrollView(.vertical){
                    Filter(categories: categories, selectedCategories: $selectedCategories)
                    .onChange(of: selectedCategories) { _, _ in
                    updateFilteredTenant()
                }
                if (sheetHeight ==  .fraction(1) || sheetHeight ==  .fraction(0.7)) {
                    VStack {
                        if searchTerm.isEmpty {
                            showTenant(tenants: filteredTenant)
                        } else {
                            doSearch(searchTerm: searchTerm)
                        }
                    }
                }
            }
        }
        .padding()
        .presentationDetents([.fraction(0.1), .fraction(0.7), .fraction(1)], selection: $sheetHeight)
        .interactiveDismissDisabled()
        .presentationBackgroundInteraction(.enabled(upThrough: maxHeight))
        .onAppear(){
            filteredTenant = tenants
        }
        .onChange(of: isTextFieldFocused, initial: false) { _, newValue in
            withAnimation {
                sheetHeight = newValue ? .fraction(0.7) : .fraction(0.1)
            }
        }
        .onChange(of: sheetHeight) { _, newValue in
            if newValue == .fraction(0.1) {
                isTextFieldFocused = false
            }
        }
    }
}
