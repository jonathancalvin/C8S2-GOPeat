//
//  ContentView.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 09/03/25.
//

import SwiftUI
import MapKit
import SwiftData
struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query var canteens: [Canteen]
    @Query var tenants: [Tenant]
    @State private var showSheet = true
    
    private func insertInitialData() {
        // Create Canteen
        let greenEatery = Canteen(name: "Green Eatery",
            latitude: -6.302180333605081,
            longitude:  106.65229958867403,
            image: "GreenEatery"
        )
        let gOP6 = Canteen(name: "GOP6",
            latitude: -6.303134809023461,
            longitude:  106.65281577080749,
            image: "GOP6"
        )
        let gOP1 = Canteen(name: "GOP1",
            latitude: -6.301780422262836,
            longitude:  106.65017405960315,
            image: "GOP1"
        )
        let theBreeze = Canteen(name: "The Breeze",
            latitude: -6.301495171206343,
            longitude:  106.65514273021897,
            image: "TheBreeze"
        )
        context.insert(greenEatery)
        context.insert(gOP6)
        context.insert(gOP1)
        context.insert(theBreeze)
        
        // Create Tenant -- greenEatery
        let mamaDjempol = Tenant(name: "Mama Djempol",
               image: "MamaDjempolGE",
               contactPerson: "08123456789",
               preorderInformation: true,
                                 operationalHours: "09:00-14:00", isHalal: true, canteen: greenEatery, priceRange: "16.000-25.000")
        let kasturi = Tenant(name: "Kasturi",
               image: "Kasturi",
               contactPerson: "08123456789",
               preorderInformation: true,
                             operationalHours: "09:00-14:00", isHalal: true, canteen: greenEatery, priceRange: "13.000-20.000")
        let laDing = Tenant(name: "La Ding",
               image: "LaDing",
               contactPerson: "08123456789",
               preorderInformation: true,
                            operationalHours: "09:00-14:00", isHalal: true, canteen: greenEatery, priceRange: "17.000-35.000")
        // TO DO - create tenant for each canteen (gOP6, gOP1, theBreeze)
        
        // Masukkan Tenant ke context
        context.insert(mamaDjempol)
        context.insert(kasturi)
        context.insert(laDing)

        
        // create food for each canteen
        let kasturiFoods = [
            Food(name: "Sapi Lada Hitam", description: "Sapi dengan saus lada hitam", categories: [.spicy, .savory, .greasy], tenant: kasturi),
            Food(name: "Sawi Putih", description: "Sawi putih rebus", categories: [.nonSpicy, .nonGreasy, .nonSweet], tenant: kasturi),
            Food(name: "Otak-Otak", description: "Otak-otak bakar khas", categories: [.nonSpicy, .nonGreasy, .nonSweet], tenant: kasturi),
            Food(name: "Telur Ponti", description: "Telur khas Pontianak", categories: [.savory, .spicy, .greasy], tenant: kasturi),
            Food(name: "Ikan Tongkol", description: "Ikan tongkol dengan bumbu", categories: [.greasy, .savory], tenant: kasturi),
            Food(name: "Kentang Mustofa", description: "Kentang goreng kering", categories: [.greasy, .sweet], tenant: kasturi),
            Food(name: "Tempe Kering", description: "Tempe goreng kering", categories: [.greasy, .savory], tenant: kasturi),
            Food(name: "Ayam Kering", description: "Ayam goreng kering", categories: [.greasy, .savory], tenant: kasturi),
            Food(name: "Teri Kacang", description: "Teri goreng dengan kacang", categories: [.nonSpicy, .greasy, .sweet], tenant: kasturi),
            Food(name: "Ayam Bakar", description: "Ayam bakar kecap", categories: [.nonSpicy, .savory, .sweet], tenant: kasturi),
            Food(name: "Ayam Rendang", description: "Ayam dengan bumbu rendang", categories: [.nonSpicy], tenant: kasturi),
            Food(name: "Ayam Gulai", description: "Ayam dengan kuah gulai", categories: [.nonGreasy, .nonSpicy], tenant: kasturi)
        ]
        
        let laDingFoods = [
            Food(name: "Soto Mie", description: "Soto mie khas Bogor", categories: [.soup, .nonSpicy, .savory], tenant: laDing),
            Food(name: "Sop Iga", description: "Sup iga sapi", categories: [.soup, .nonSpicy, .savory], tenant: laDing),
            Food(name: "Sop Daging", description: "Sup daging sapi", categories: [.soup, .nonSpicy, .savory], tenant: laDing),
            Food(name: "Somay", description: "Siomay khas Bandung", categories: [.savory], tenant: laDing),
            Food(name: "Nasi Uduk", description: "Nasi gurih khas Jakarta", categories: [.savory], tenant: laDing)
        ]
        
        let mamaDjempolFoods = [
            Food(name: "Ayam Lada Hitam", description: "Ayam dengan saus lada hitam", categories: [.nonGreasy, .spicy, .savory], tenant: mamaDjempol),
            Food(name: "Ayam Jamur Kancing", description: "Ayam dengan jamur kancing", categories: [.nonGreasy, .nonSpicy, .savory], tenant: mamaDjempol),
            Food(name: "Ayam Saus Madu", description: "Ayam dengan saus madu", categories: [.greasy, .nonSpicy, .savory], tenant: mamaDjempol),
            Food(name: "Ayam Pedas Manis", description: "Ayam dengan bumbu pedas manis", categories: [.greasy, .spicy, .savory], tenant: mamaDjempol),
            Food(name: "Ayam Saus Padang", description: "Ayam dengan saus Padang", categories: [.greasy, .spicy, .savory], tenant: mamaDjempol),
            Food(name: "Ayam Sambal Hijau", description: "Ayam dengan sambal hijau", categories: [.greasy, .spicy, .savory], tenant: mamaDjempol),
            Food(name: "Ayam Suwir", description: "Ayam suwir pedas", categories: [.greasy, .spicy, .savory], tenant: mamaDjempol),
            Food(name: "Ikan Dori", description: "Ikan dori goreng", categories: [.greasy, .nonSpicy, .savory], tenant: mamaDjempol),
            Food(name: "Cumi Rica", description: "Cumi dengan bumbu rica", categories: [.greasy, .spicy, .savory], tenant: mamaDjempol),
            Food(name: "Ikan Tongkol Balado", description: "Ikan tongkol dengan balado", categories: [.greasy, .spicy, .savory], tenant: mamaDjempol),
            Food(name: "Tempe Orek", description: "Tempe goreng kecap", categories: [.greasy, .nonSpicy, .savory], tenant: mamaDjempol),
            Food(name: "Kangkung", description: "Tumis kangkung", categories: [.nonGreasy, .spicy, .savory], tenant: mamaDjempol),
            Food(name: "Sayur Toge", description: "Tumis toge", categories: [.nonGreasy, .nonSpicy], tenant: mamaDjempol)
        ]
        //TO DO - create food for other tenant
        
        // Insert semua data ke dalam modelContext
        let allFoods = kasturiFoods + laDingFoods + mamaDjempolFoods
        for food in allFoods {
            context.insert(food)
        }
        do {
            try context.save()
        } catch {
            fatalError(error.localizedDescription)
        }
        print("Insert Initial Data Success")
        print("===============================")
    }
    
    private func deleteInitialData(){
        do {
            let canteens = try context.fetch(FetchDescriptor<Canteen>())
            for canteen in canteens {
                context.delete(canteen)
            }
            
            let tenants = try context.fetch(FetchDescriptor<Tenant>())
            for tenant in tenants {
                context.delete(tenant)
            }
            
            let foods = try context.fetch(FetchDescriptor<Food>())
            for food in foods {
                context.delete(food)
            }
            
            try context.save()
        } catch {
            fatalError(error.localizedDescription)
        }
        
        print("Delete Initial Success")
        print("===============================")
    }
    private func showInsertedData() {
        for canteen in canteens {
            print("=== Canteens ===")
            print("Nama: \(canteen.name), Lokasi: (\(canteen.latitude), \(canteen.longitude))")
            for tenant in canteen.tenants {
                print("Nama: \(tenant.name) Halal: \( (tenant.isHalal ?? false) ? "Yes" : "No")")
                for food in tenant.foods {
                    print("Nama: \(food.name), Deskripsi: \(food.desc), Tenant: \(food.tenant?.name ?? "Unknown")")
                }
            }
        }
    }
    var body: some View {
        VStack {
            Map(){
                ForEach(canteens){ canteen in
                    Marker(canteen.name, coordinate: CLLocationCoordinate2D(latitude: canteen.latitude, longitude: canteen.longitude))
                }
            }
        }
        .onAppear(){
            deleteInitialData()
            insertInitialData()
            showInsertedData()
        }
        .sheet(isPresented: $showSheet) {
            ModalSearchComponent(tenantSearchViewModel: TenantSearchViewModel(tenants: tenants))
        }
    }
}

#Preview {
    ContentView()
}
