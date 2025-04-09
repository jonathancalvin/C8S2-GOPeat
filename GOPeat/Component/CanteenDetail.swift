//
//  CanteenDetail.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 07/04/25.
//

import SwiftUI
import MapKit
import SwiftData

struct CanteenDetail: View {
    let canteen: Canteen
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
                            Text(canteen.name)
                                .font(.title2)
                                .bold()
                            
                            Text(canteen.desc)
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
                        
                        Text(canteen.operationalTime)
                            .font(.subheadline)
                    }
                    
                    Divider()
                    
                    // Amenities Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("AMENITIES")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 8) {
                            ForEach(canteen.amenities, id: \.self) { amenity in
                                Label(amenity, systemImage: amenityIcon(for: amenity))
                                    .font(.subheadline)
                                    .padding(8)
                                    .background(Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                    
                    // Map Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("LOCATION")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Map {
                            Annotation("", coordinate: CLLocationCoordinate2D(latitude: canteen.latitude, longitude: canteen.longitude)) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.red)
                            }
                        }
                        .frame(height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .allowsHitTesting(false)
                    }
                    
                    // Tenants Section
//                    showTenant(tenants: canteen.tenants.sorted(by: { $0.name < $1.name })) // Ensure tenants is not nil and sort them
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
        case "ATM": return "banknote"
        case "Printing Services": return "printer"
        case "Disabled Access": return "figure.roll"
        case "Smoking Area": return "smoke"
        case "Convenience Store": return "cart"
        case "Live Music": return "music.mic"
        case "Event Space": return "calendar"
        case "Premium Dining": return "star"
        case "Prayer Room": return "mosque" // Added prayer room icon
        default: return "mappin"
        }
    }
}

#Preview {
    // You'll need to create a dummy Canteen object for the preview
    let dummyCanteen = Canteen(name: "Green Eatery", latitude: -6.302180333605081, longitude: 106.65229958867403, image: "GreenEatery", desc: "Modern food court featuring diverse dishes", operationalTime: "Monday - Friday: 6 AM - 9 PM", amenities: ["Disabled Access", "Smoking Area", "Convenience Store"])
    return CanteenDetail(canteen: dummyCanteen, dismissAction: {})
}
