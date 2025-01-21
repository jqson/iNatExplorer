//
//  MyNaturalistApp.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/3/24.
//

import SwiftUI
import SwiftData

@main
struct MyNaturalistApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Filter.self)
    }
}
