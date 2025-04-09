//
//  CanteenDetail.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 07/04/25.
//

import SwiftUI
import MapKit

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
                    
                    // Map Preview
                    VStack(alignment: .leading, spacing: 8) {
                        Text("LOCATION")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Map(initialPosition: .region(MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: canteen.latitude, longitude: canteen.longitude),
                            span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
                        ))) {
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
