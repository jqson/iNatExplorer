//
//  CategorySelectionView.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 12/27/24.
//

import SwiftUI

struct CategorySelectionView: View {
    
    private let categories: [CategoryStruct] = Category.allCases.map { $0.category }
    
    var body: some View {
        NavigationStack {
            VStack {
                ForEach(categories) { category in
                    NavigationLink(destination: SpeciesListView(category: category)) {
                        Label(category.name, systemImage: category.systemIcon)
                            .font(.title3)
                            .frame(height: 40)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .buttonStyle(.borderedProminent)
                    .navigationTitle("Category")
                }
            }
            .padding()
        }
    }
}

#Preview {
    CategorySelectionView()
}
