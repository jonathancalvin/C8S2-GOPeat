//
//  TenantCard.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 07/04/25.
//

import SwiftUI

struct TenantCard: View {
    let tenant: Tenant
//    let onTenantSelected: (Tenant) -> Void
    private func infoRow(label: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text("\(label):")
            Spacer()
            Text(value)
        }
        .font(.caption)
        .foregroundColor(.primary)
    }

    var body: some View {
        
        NavigationLink(){
            
        } label: {
            HStack {
                Image(tenant.image)
                    .resizable()
                    .frame(maxWidth: 80, maxHeight: 80)
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack(alignment: .leading) {
                    Text(tenant.name)
                        .font(.subheadline)
                        .bold()
                        .padding(.bottom,5)
                    infoRow(label: "Operational Hours", value: tenant.operationalHours)
                    infoRow(label: "Contact Person", value: tenant.contactPerson)
                    infoRow(label: "Pre-order Information", value: "\((tenant.preorderInformation ?? false) ? "Available" : "Not available")")
                }
                
                Spacer()
            }
            .padding(10)
            .background(Color(.systemGray5).opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        
        
//        Button(action: {
//            onTenantSelected(tenant)
//        }) {
//            HStack {
//                Image(tenant.image)
//                    .resizable()
//                    .frame(maxWidth: 80, maxHeight: 80)
//                    .scaledToFill()
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                
//                VStack(alignment: .leading) {
//                    Text(tenant.name)
//                        .font(.subheadline)
//                        .bold()
//                        .padding(.bottom,5)
//                    infoRow(label: "Operational Hours", value: tenant.operationalHours)
//                    infoRow(label: "Contact Person", value: tenant.contactPerson)
//                    infoRow(label: "Pre-order Information", value: "\((tenant.preorderInformation ?? false) ? "Available" : "Not available")")
//                }
//                
//                Spacer()
//            }
//            .padding(10)
//            .background(Color(.systemGray5).opacity(0.3))
//            .clipShape(RoundedRectangle(cornerRadius: 10))
//        }
//        .buttonStyle(.plain)
    }
}
