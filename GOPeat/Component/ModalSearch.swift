import SwiftUI
import SwiftData

struct ModalSearchComponent: View {
    @Binding var searchTerm: String
    @FocusState var isTextFieldFocused: Bool
    @State private var sheetHeight: PresentationDetent = .fraction(0.1)
    private let maxHeight: PresentationDetent = .fraction(1)
    let tenants: [Tenant]
    
    private func doSearch(searchTerm: String) -> some View{
        let loweredCaseString = searchTerm.lowercased()
        let result = tenants.filter { tenant in
            tenant.name.lowercased()
                .contains(loweredCaseString) || tenant.foods.contains { food in
                food.name.lowercased().contains(loweredCaseString)
            }
        }
        return showTenant(tenants: result)
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
                if (sheetHeight ==  .fraction(1) || sheetHeight ==  .fraction(0.7)) {
                    VStack {
                        if searchTerm.isEmpty {
                            showTenant(tenants: tenants)
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
