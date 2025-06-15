//
//  SpeciesListView.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 12/19/24.
//

import SwiftUI

extension SavedSpecies.Label {
    var iconImage: String {
        switch self {
        case .observed:
            return "binoculars.fill"
        case .favorite:
            return "heart.fill"
        }
    }
    
    var iconActiveColor: Color {
        switch self {
        case .observed:
            return .orange
        case .favorite:
            return .pink
        }
    }
}

struct SpeciesListView: View {
    
    enum Constants {
        static let iconLabels: [SavedSpecies.Label] = [.observed, .favorite]
        static let labelIconSize: CGFloat = 32
    }
    
    var category: CategoryStruct
    
    @StateObject private var speciesItemViewModel: SpeciesItemViewModel
        = SpeciesItemViewModel(dataService: .shared)
    @State private var isLoading: Bool = true
    
    var body: some View {
        ZStack {
            ScrollView {
                Text(speciesItemViewModel.speciesCountText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                Toggle("Only Show Unobserved", isOn: $speciesItemViewModel.hideObserved)
                    .padding(.horizontal)
                    .listRowSeparator(.hidden)
                
                LazyVGrid(
                    columns: .init(repeating: GridItem(),count: 3),
                    alignment: .leading
                ) {
                    ForEach(speciesItemViewModel.speciesSections) { section in
                        Section {
                            ForEach(section.speciesItem) { speciesItem in
                                NavigationLink {
                                    SpeciesDetailView(
                                        species: speciesItem.species,
                                        speciesItemViewModel: speciesItemViewModel
                                    )
                                } label: {
                                    SpeciesItemView(
                                        speciesItem: speciesItem,
                                        speciesItemViewModel: speciesItemViewModel
                                    )
                                }
                                .navigationTitle("Species List")
                            }
                        } header: {
                            Text(section.title)
                                .bold()
                                .padding([.leading, .trailing, .top])
                                .padding(.bottom, 3)
                        }
                    }
                }
                .task {
                    guard isLoading else { return }
                    
                    await speciesItemViewModel.fetchData(category: category)
                    
                    isLoading = false
                }
            }
            
            ZStack {
                Color(UIColor.systemBackground)
                    .edgesIgnoringSafeArea(.all)
                ProgressView()
                    .scaleEffect(2)
            }
            .opacity(isLoading ? 1 : 0)
        }
    }
}

#Preview {
    SpeciesListView(category: Category.bird.category)
}
