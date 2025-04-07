//
//  Canteen.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 26/03/25.
//

import Foundation
import SwiftData
@Model
class Canteen: Identifiable {
    var id: UUID = UUID()
    var name: String
    var latitude: Double
    var longitude: Double
    var image: String
    var desc: String
    var amenities: [String]
    var operationalTime: String
    @Relationship(deleteRule: .cascade) var tenants: [Tenant] = []
    init(name: String, latitude: Double,longitude: Double, image: String, desc: String, operationalTime: String, amenities: [String]) {
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
        self.image = image
        self.desc = desc
        self.operationalTime = operationalTime
        self.amenities = amenities
    }
}
