//
//  GOPeatApp.swift
//  GOPeat
//
//  Created by jonathan calvin sutrisna on 09/03/25.
//

import SwiftUI
import SwiftData
@main
struct GOPeat: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Canteen.self, Tenant.self, Food.self])
    }
}
