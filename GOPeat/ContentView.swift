import SwiftUI
import MapKit
import CoreLocation

// --- Data Model for Locations ---
struct Location: Identifiable, Equatable, Hashable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let description: String
    let hours: String
    let amenities: [String]
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    
    // Add hash function for Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// Global function for location color
func locationColor(for name: String) -> Color {
    switch name {
    case "GOP 1 Canteen": return .red
    case "GOP 6 Canteen": return .blue
    case "GOP 9 Canteen": return .green
    case "The Breeze Food Court": return .orange
    default: return .purple
    }
}

// --- Search Modal View ---
struct SearchModalView: View {
    @Binding var searchTerm: String
    @FocusState var isTextFieldFocused: Bool
    @State private var sheetHeight: PresentationDetent = .fraction(0.1)
    private let maxHeight: PresentationDetent = .fraction(1)
    
    let locations: [Location]
    var onLocationSelected: (Location) -> Void

    private var filteredLocations: [Location] {
        searchTerm.isEmpty ? locations : locations.filter {
            $0.name.lowercased().contains(searchTerm.lowercased())
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    // Search Bar
                    HStack(spacing: 0) {
                        HStack(spacing: 5) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(searchTerm.isEmpty ? .gray : .blue)

                            TextField("Search locations...", text: $searchTerm)
                                .focused($isTextFieldFocused)
                                .textFieldStyle(.plain)
                                .autocorrectionDisabled()
                        }
                        .padding(10)
                        .background(Color(.systemGray5))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.trailing, 10)
                        
                        if isTextFieldFocused {
                            Button("Cancel") {
                                searchTerm = ""
                                isTextFieldFocused = false
                            }
                            .transition(.move(edge: .trailing))
                        }
                    }
                    .animation(.default, value: isTextFieldFocused)

                    // Results
                    if sheetHeight != .fraction(0.1) {
                        VStack(spacing: 12) {
                            ForEach(filteredLocations, id: \.self) { location in
                                Button(action: {
                                    onLocationSelected(location)
                                }) {
                                    HStack {
                                        Image(systemName: "mappin.circle.fill")
                                            .foregroundColor(locationColor(for: location.name))
                                        
                                        VStack(alignment: .leading) {
                                            Text(location.name)
                                                .font(.subheadline)
                                                .bold()
                                            Text(location.description)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                                .lineLimit(1)
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(10)
                                    .background(Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .transition(.opacity.combined(with: .slide))
                        .padding(.top)
                    }
                }
                .padding()
            }
            .presentationDetents([.fraction(0.1), .fraction(0.7), .fraction(1)], selection: $sheetHeight)
            .interactiveDismissDisabled()
            .presentationBackgroundInteraction(.enabled(upThrough: maxHeight))
            .onChange(of: isTextFieldFocused) { _, newValue in
                withAnimation(.spring()) {
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

// --- Main Content View ---
struct ContentView: View {
    @State private var camera: MapCameraPosition = .automatic
    @State private var searchTerm = ""
    @State private var selectedLocation: Location?
    @State private var showDetail = false
    @State private var showSearchModal = true
    @State private var mapOffset: CGFloat = 0 // New offset state

    private let locations: [Location] = [
        Location(
            name: "GOP 1 Canteen",
            coordinate: CLLocationCoordinate2D(latitude: -6.301780, longitude: 106.650174),
            description: "Main cafeteria at GOP 1 offering various cuisines",
            hours: "Monday - Friday: 7 AM - 7 PM",
            amenities: ["Free WiFi", "Air Conditioned", "Outdoor Seating"]
        ),
        Location(
            name: "GOP 6 Canteen",
            coordinate: CLLocationCoordinate2D(latitude: -6.303134, longitude: 106.652815),
            description: "Popular food court with multiple food stalls",
            hours: "Monday - Saturday: 6:30 AM - 8 PM",
            amenities: ["Prayer Room", "ATM", "Printing Services"]
        ),
        Location(
            name: "GOP 9 Canteen",
            coordinate: CLLocationCoordinate2D(latitude: -6.302180, longitude: 106.652299),
            description: "Modern food court featuring diverse dishes",
            hours: "Monday - Friday: 6 AM - 9 PM",
            amenities: ["Disabled Access", "Smoking Area", "Convenience Store"]
        ),
        Location(
            name: "The Breeze Food Court",
            coordinate: CLLocationCoordinate2D(latitude: -6.301495, longitude: 106.655142),
            description: "Spacious food court with outdoor seating",
            hours: "Daily: 8 AM - 10 PM",
            amenities: ["Live Music", "Event Space", "Premium Dining"]
        )
    ]

    private func zoomToLocation(_ coordinate: CLLocationCoordinate2D) {
        withAnimation(.easeInOut(duration: 0.5)) {
            // Move the pin to the top 1/3 of the screen
            mapOffset = -UIScreen.main.bounds.height * 0.25
            
            let region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
            )
            camera = .region(region)
        }
    }

    private func handleLocationSelection(_ location: Location) {
        selectedLocation = location
        zoomToLocation(location.coordinate)
        showDetail = true
        showSearchModal = false
        searchTerm = ""
    }

    var body: some View {
        ZStack {
            // Map View with Offset
            Map(position: $camera) {
                ForEach(locations) { location in
                    Annotation(location.name, coordinate: location.coordinate) {
                        ZStack {
                            Circle()
                                .fill(.white)
                                .frame(width: 30, height: 30)
                            
                            Image(systemName: "fork.knife.circle.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(locationColor(for: location.name))
                                .scaleEffect(selectedLocation?.id == location.id ? 1.3 : 1.0)
                        }
                        .shadow(radius: 5)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                handleLocationSelection(location)
                            }
                        }
                    }
                }
            }
            .padding(.top, mapOffset) // Apply the offset here
            .mapStyle(.standard)
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
            .edgesIgnoringSafeArea(.all)
            .background(Color.clear) // Add this line

            // Current Location Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            camera = .automatic
                            mapOffset = 0 // Reset offset
                        }
                    }) {
                        Image(systemName: "location.fill")
                            .padding(12)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 50)
                }
            }
        }
        .sheet(isPresented: $showDetail, onDismiss: {
            withAnimation(.easeInOut(duration: 0.3)) {
                selectedLocation = nil
                showSearchModal = true
                mapOffset = 0 // Reset offset when modal closes
            }
        }) {
            if let location = selectedLocation {
                LocationDetailView(location: location, dismissAction: {
                    showDetail = false
                })
                .presentationDetents([.medium])
            }
        }
        .sheet(isPresented: $showSearchModal, onDismiss: {}) {
            SearchModalView(
                searchTerm: $searchTerm,
                locations: locations,
                onLocationSelected: handleLocationSelection
            )
        }
    }
}

// --- Location Detail View ---
struct LocationDetailView: View {
    let location: Location
    var dismissAction: () -> Void
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    HStack(alignment: .top) {
                        Image(systemName: "fork.knife.circle.fill")
                            .foregroundStyle(.red)
                            .font(.system(size: 36))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(location.name)
                                .font(.title2)
                                .bold()
                            
                            Text(location.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.bottom, 8)
                    
                    Divider()
                    
                    // Hours Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("OPERATING HOURS")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(location.hours)
                            .font(.subheadline)
                    }
                    
                    Divider()
                    
                    // Amenities Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("AMENITIES")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 8) {
                            ForEach(location.amenities, id: \.self) { amenity in
                                Label(amenity, systemImage: amenityIcon(for: amenity))
                                    .font(.subheadline)
                                    .padding(8)
                                    .background(Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                    
                    // Map Preview
                    VStack(alignment: .leading, spacing: 8) {
                        Text("LOCATION")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Map(initialPosition: .region(MKCoordinateRegion(
                            center: location.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
                        ))) {
                            Annotation("", coordinate: location.coordinate) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.red)
                            }
                        }
                        .frame(height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .allowsHitTesting(false)
                    }
                    .padding(.top)
                }
                .padding()
            }
            .navigationTitle("Location Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done", action: dismissAction)
                }
            }
        }
    }
    
    private func amenityIcon(for amenity: String) -> String {
        switch amenity {
        case "Free WiFi": return "wifi"
        case "Air Conditioned": return "air.conditioner.horizontal"
        case "Outdoor Seating": return "table.furniture"
        case "Prayer Room": return "pray"
        case "ATM": return "banknote"
        case "Printing Services": return "printer"
        case "Disabled Access": return "figure.roll"
        case "Smoking Area": return "smoke"
        case "Convenience Store": return "cart"
        case "Live Music": return "music.mic"
        case "Event Space": return "calendar"
        case "Premium Dining": return "star"
        default: return "mappin"
        }
    }
}

#Preview {
    ContentView()
}
