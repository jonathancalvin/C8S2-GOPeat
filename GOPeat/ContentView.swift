import SwiftUI
import MapKit
import CoreLocation

// Keep this extension, it's potentially useful
// Removed problematic extension

// --- Data Model for Locations ---
struct Location: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let description: String
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}

// --- Search Modal View (Cleaned Up) ---
struct SearchModalView: View {
    @Binding var searchTerm: String
    @FocusState var isTextFieldFocused: Bool
    @State private var sheetHeight: PresentationDetent = .fraction(0.1)
    private let maxHeight: PresentationDetent = .fraction(1)
    
    let dummyData = [
        "iPhone 15",
        "MacBook Air M2",
        "SwiftUI Animation",
        "Tesla Model 3",
        "WWDC 2024",
        "iOS 18 Features",
        "Best Coding Bootcamps",
        "Xcode Tips and Tricks",
        "Apple Vision Pro",
        "AI in Mobile Apps"
    ]

    private func doSearch(tenant: String) -> [String] {
        let loweredCaseString = tenant.lowercased()
        return dummyData.filter {
            $0.lowercased().contains(loweredCaseString)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    HStack(spacing: 0) {
                        HStack(spacing: 5) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(searchTerm.isEmpty ? .gray : .blue)

                            TextField("Search", text: $searchTerm)
                                .focused($isTextFieldFocused)
                                .textFieldStyle(.plain)
                                .autocorrectionDisabled()
                        }
                        .padding(10)
                        .background(Color(.systemGray5))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.trailing, 10)
                        
                        if isTextFieldFocused {
                            Button(action: {
                                searchTerm = ""
                                isTextFieldFocused = false
                            }) {
                                Text("Cancel")
                            }
                        }
                    }

                    if (sheetHeight == .fraction(1) || sheetHeight == .fraction(0.7)) {
                        VStack {
                            ForEach(searchTerm.isEmpty ? dummyData : doSearch(tenant: searchTerm), id: \.self) { data in
                                Text(data)
                            }
                        }
                    }
                    Spacer().border(.black)
                }
                .padding()
                .presentationDetents([.fraction(0.1), .fraction(0.7), .fraction(1)], selection: $sheetHeight)
                .interactiveDismissDisabled()
                .presentationBackgroundInteraction(.enabled(upThrough: maxHeight))
                .onChange(of: isTextFieldFocused) { _, newValue in
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
    }
}

// --- New Detail Modal View ---
struct LocationDetailView: View {
    @Binding var selectedLocation: Location?
    @State private var sheetHeight: PresentationDetent = .fraction(0.7)
    private let maxHeight: PresentationDetent = .fraction(1)
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 15) {
                    // Location Title
                    HStack {
                        Image(systemName: "fork.knife.circle.fill")
                            .foregroundStyle(.red)
                        Text(selectedLocation?.name ?? "")
                            .font(.title)
                            .bold()
                    }
                    .padding(.bottom)
                    
                    // Location Details
                    Group {
                        Section(header: Text("Opening Hours").font(.headline)) {
                            Text("Monday - Friday: 7 AM - 7 PM")
                            Text("Saturday: 8 AM - 5 PM")
                            Text("Sunday: Closed")
                        }
                        .padding(.vertical)
                        
                        Section(header: Text("Available Services").font(.headline)) {
                            Text("• Food Court Area")
                            Text("• Indoor & Outdoor Seating")
                            Text("• Free WiFi")
                            Text("• Prayer Room")
                            Text("• Restrooms")
                        }
                        .padding(.vertical)
                        
                        Section(header: Text("Popular Items").font(.headline)) {
                            Text("• Local Indonesian Cuisine")
                            Text("• Chinese Food")
                            Text("• Japanese Food")
                            Text("• Western Food")
                            Text("• Beverages & Snacks")
                        }
                        .padding(.vertical)
                    }
                }
                .padding()
            }
            .presentationDetents([.fraction(0.1), .fraction(0.7), .fraction(1)], selection: $sheetHeight)
            .presentationBackgroundInteraction(.enabled(upThrough: maxHeight))
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        selectedLocation = nil
                    }
                }
            }
        }
    }
}

// --- Main Content View (Refactored) ---
struct ContentView: View {
    // Map Camera State
    @State private var camera: MapCameraPosition = .automatic

    // Search Sheet State
    @State private var searchTerm = ""

    // Detail Sheet State
    @State private var selectedLocation: Location?

    // Location Data (using the Location struct)
    private let locations: [Location] = [
        Location(
            name: "GOP 1 Canteen",
            coordinate: CLLocationCoordinate2D(
                latitude: -6.301780422262836,
                longitude: 106.65017405960315
            ),
            description: "Main cafeteria at GOP 1 offering various Indonesian and international cuisines"
        ),
        Location(
            name: "GOP 6 Canteen",
            coordinate: CLLocationCoordinate2D(
                latitude: -6.303134809023461,
                longitude: 106.65281577080749
            ),
            description: "Popular food court at GOP 6 with multiple food stalls and seating areas"
        ),
        Location(
            name: "GOP 9 Canteen",
            coordinate: CLLocationCoordinate2D(
                latitude: -6.302180333605081,
                longitude: 106.65229958867403
            ),
            description: "Modern food court at GOP 9 featuring local and international dishes"
        ),
        Location(
            name: "The Breeze Food Court",
            coordinate: CLLocationCoordinate2D(
                latitude: -6.301495171206343,
                longitude: 106.65514273021897
            ),
            description: "Spacious food court with outdoor seating and diverse dining options"
        )
    ]

    // Function to center map (renamed and simplified)
    private func zoomToLocation(_ coordinate: CLLocationCoordinate2D) {
        camera = .region(MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        ))
    }

    var body: some View {
        ZStack {
            Map(position: $camera) {
                ForEach(locations) { location in
                    Annotation(location.name, coordinate: location.coordinate) {
                        Image(systemName: "fork.knife.circle.fill")
                            .padding(4)
                            .foregroundStyle(.red)
                            .background(.white)
                            .clipShape(Circle())
                            .scaleEffect(selectedLocation?.id == location.id ? 1.2 : 1.0)
                            .animation(.spring(), value: selectedLocation?.id)
                            .onTapGesture {
                                selectedLocation = location
                                zoomToLocation(location.coordinate)
                            }
                    }
                }
            }
            .mapStyle(.standard)
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
            .edgesIgnoringSafeArea(.all)
        }
        .sheet(isPresented: .constant(true)) {
            if let location = selectedLocation {
                LocationDetailView(selectedLocation: $selectedLocation)
            } else {
                SearchModalView(searchTerm: $searchTerm)
            }
        }
    }
}

// --- Add Coordinate Constants (Optional but Clean) ---
extension CLLocationCoordinate2D {
    static let gop1 = CLLocationCoordinate2D(latitude: -6.301780, longitude: 106.650174)
    static let gop6 = CLLocationCoordinate2D(latitude: -6.303134, longitude: 106.652815)
    static let gop9 = CLLocationCoordinate2D(latitude: -6.302180, longitude: 106.652299)
    static let tb = CLLocationCoordinate2D(latitude: -6.301495, longitude: 106.655142)
    static let bsdGreenOfficePark = CLLocationCoordinate2D(latitude: -6.302, longitude: 106.6525)
}

#Preview {
    ContentView()
}
