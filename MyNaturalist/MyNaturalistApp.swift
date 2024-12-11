//
//  MyNaturalistApp.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/3/24.
//

import SwiftUI
import GoogleMaps

@main
struct MyNaturalistApp: App {
    
    init() {
        GMSServices.provideAPIKey("AIzaSyDQPAmqBULGhHwOj8LPrsHSTn-r-bYfKo4")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
