// Tenant Page Backup Apr 8



//  CanteenCard.swift
//  GOPeat
//
//  Created by Oxa Marvel on 24/03/25.
//


import SwiftUI

let sampleImages = ["image1", "image2", "image3", "image4", "image5"]

// Tenant Page
struct TenantView: View {
    @Environment(\.dismiss) var dismiss
    let foods: [Food]
    let tenant: Tenant
    
    init(tenant: Tenant, foods: [Food]) {
        self.foods = foods
        self.tenant = tenant
        
        let appear = UINavigationBarAppearance()
        
        appear.backgroundColor = .white
        appear.shadowColor = .clear
        appear.shadowImage = UIImage()
        
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().standardAppearance = appear
        UINavigationBar.appearance().compactAppearance = appear
        UINavigationBar.appearance().scrollEdgeAppearance = appear
        
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        NavigationView {
            ZStack (alignment: .top){
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Tenant Header & Description
                        VStack(alignment: .leading, spacing: 10) {
                            VStack (alignment: .leading) {
                                Text("Mama Djempol")
                                    .font(.largeTitle.bold())
                                Text("Green Eatery")
                                    .font(.body)
                                //.foregroundColor(.gray)
                                Spacer()
                            }

                            
                            HStack() {
                                VStack(alignment: .leading, spacing: 10) {
                                    (Text(Image(systemName: "clock")) +
                                     Text(" 09:00-14:00")
                                        .font(.body)
                                     )
                                    
                                    HStack() {
                                        (Text(Image(systemName: "phone")) +
                                         Text(" 08123456789")
                                            .font(.body) +
                                         Text(" (Pre-order")
                                         )
                                        
                                        if /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/ {
                                            (Text(Image(systemName: "checkmark.circle.fill")).foregroundColor(.green) +
                                             Text(")"))
                                            .font(.body)
                                        } else {
                                            (Text(Image(systemName: "xmark.circle.fill")).foregroundColor(.red) +
                                             Text(")"))
                                            .font(.body)
                                        }
                                        
                                    }
                                }
                                
                                Spacer()
                                
                                if true {
                                    Image("halal")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                } else {
                                    /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
                                }
                            }
                        }
                        .padding(.horizontal)
                        // Tenant Header & Description
                        
                        
                        // Tenant's Side-scrolling images
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(sampleImages, id: \.self) { imageName in
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 150, height: 200)
                                        .overlay(
                                            Image(systemName: "photo")
                                                .font(.system(size: 50))
                                                .foregroundColor(.gray)
                                        )
                                }
                            }
                            .padding(.horizontal)
                        }
                        // Tenant's Side-scrolling Images
                        
                        
                        // Filter Component

                        // Filter Component
                        
                        
                        // List of Food
                        VStack(spacing: 10) {
                            ForEach(foods) { food in
                                FoodCard(food: food)
                            }
                        }
                        .padding(.horizontal)
                        // List of Foods
                    }
                    .padding(.vertical)
                }
                .scrollIndicators(.hidden)
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        (Text(Image(systemName: "chevron.left"))
                         + Text(" Back"))
                    }
                }
            }
        }
    }
}
// Tenant Page


// Food Card
struct FoodCard: View {
    let food: Food
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(food.name)
                    .font(.headline)
                    
                Text(food.desc)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
                
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.07))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.0), lineWidth: 1)
        )
    }
}
// Food Card
