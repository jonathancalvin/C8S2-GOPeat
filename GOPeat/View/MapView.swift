//
//  MapView.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 07/04/25.
//

import SwiftUI
import MapKit
// Global function for location color
func locationColor(for name: String) -> Color {
    switch name {
    case "GOP 1 Canteen": return .red
    case "GOP 6 Canteen": return .blue
    case "Green Eatery": return .green
    case "The Breeze Food Court": return .orange
    default: return .purple
    }
}

struct MapView: View {
    @State private var camera: MapCameraPosition = .automatic
    @State private var selectedCanteen: Canteen?
    @State private var showDetail = false
    @State private var showSearchModal = true
    @State private var mapOffset: CGFloat = 0
    
    let tenants: [Tenant]
    let canteens: [Canteen]
    
    @StateObject private var tenantSearchViewModel: TenantSearchViewModel
    
    init(tenants: [Tenant], canteens: [Canteen]) {
        self.tenants = tenants
        self.canteens = canteens
        _tenantSearchViewModel = StateObject(wrappedValue: TenantSearchViewModel(tenants: tenants))
    }
    
    private func zoomToLocation(_ coordinate: CLLocationCoordinate2D) {
        withAnimation(.easeInOut(duration: 0.5)) {
            mapOffset = -UIScreen.main.bounds.height * 0.25
            let region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
            )
            camera = .region(region)
        }
    }
    
    private func handleCanteenSelection(_ canteen: Canteen) {
        selectedCanteen = canteen
        let coordinate = CLLocationCoordinate2D(latitude: canteen.latitude, longitude: canteen.longitude)
        zoomToLocation(coordinate)
        showDetail = true
        showSearchModal = false
        tenantSearchViewModel.onClose()
    }
    
    private func handleTenantSelection(_ tenant: Tenant) {
        guard let canteen = tenant.canteen else { return }
        let coordinate = CLLocationCoordinate2D(latitude: canteen.latitude, longitude: canteen.longitude)
        zoomToLocation(coordinate)
        tenantSearchViewModel.onClose()
        showSearchModal = false
        // TO DO: Navigate to Tenant Page
    }
    private func annotationContent(for canteen: Canteen) -> some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: 30, height: 30)
            
            Image(systemName: "fork.knife.circle.fill")
                .font(.system(size: 24))
                .foregroundStyle(locationColor(for: canteen.name))
                .scaleEffect(selectedCanteen?.id == canteen.id ? 1.3 : 1.0)
        }
        .shadow(radius: 5)
        .onTapGesture {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                handleCanteenSelection(canteen)
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Map View with Offset
            Map(position: $camera) {
                ForEach(canteens) { canteen in
                    Annotation(canteen.name, coordinate: CLLocationCoordinate2D(latitude: canteen.latitude, longitude: canteen.longitude)){
                        annotationContent(for: canteen)
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
                selectedCanteen = nil
                showSearchModal = true
                mapOffset = 0 // Reset offset when modal closes
            }
        }) {
            if let canteen = selectedCanteen {
                CanteenDetail(canteen: canteen, dismissAction: {
                    showDetail = false
                })
                .presentationDetents([.medium])
            }
        }
        .sheet(isPresented: $showSearchModal, onDismiss: {}) {
            ModalSearch(
                tenantSearchViewModel: tenantSearchViewModel
            )
        }
    }
}
