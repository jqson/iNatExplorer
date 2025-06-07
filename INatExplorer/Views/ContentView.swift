//
//  ContentView.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 12/3/24.
//

import SwiftUI

struct ContentView: View {
    
    enum Tabs {
        case species
        case search
    }
    
    @State private var selection: Tabs = .species
    
    var body: some View {
        TabView(selection: $selection) {
            Tab("Species", systemImage: "bird", value: .species) {
                CategorySelectionView()
            }
            
            Tab("Search", systemImage: "magnifyingglass", value: .search) {
                SearchView()
                    .tag(Tabs.search)
            }
        }
    }
}

#Preview {
    ContentView()
}
