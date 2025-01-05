//
//  BuyMeApp.swift
//  BuyMe
//
//  Created by Γιάννης on 20/9/24.
//

import SwiftUI

@main
struct BuyMeApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
}
