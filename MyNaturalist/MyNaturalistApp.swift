//
//  MyNaturalistApp.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/3/24.
//

import SwiftUI

@main
struct MyNaturalistApp: App {
    
    @StateObject var filterManager = FilterManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environmentObject(filterManager)
    }
}
