//
//  SpeciesListView.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 12/19/24.
//

import SwiftUI

struct SpeciesListView: View {
    
    var category: CategoryStruct
    @Binding var selectedTimeRange: DateUtil.TimeRange
    
    @StateObject private var speciesItemViewModel: SpeciesItemViewModel
        = SpeciesItemViewModel(dataService: .shared)
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            ScrollView {
                TimeRangePickerView(selectedTimeRange: $selectedTimeRange)
                .onChange(of: selectedTimeRange) {
                    Task {
                        await fetchData()
                    }
                }
                
                Text(speciesItemViewModel.speciesCountText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                Toggle("Only Show Favorited", isOn: $speciesItemViewModel.favoriteOnly)
                    .padding(.horizontal)
                    .listRowSeparator(.hidden)
                
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
                    await fetchData()
                }
            }
            
            ZStack {
                Color(UIColor.systemBackground)
                    .edgesIgnoringSafeArea(.all)
                ProgressView()
                    .scaleEffect(2)
            }
            .opacity(isLoading ? 0.8 : 0)
        }
    }
    
    private func fetchData() async {
        isLoading = true
        
        await speciesItemViewModel.fetchData(
            category: category, timeRange: selectedTimeRange
        )
        
        isLoading = false
    }
}

#Preview {
    @Previewable @State var selectedTimeRange: DateUtil.TimeRange = .year
    
    SpeciesListView(category: Category.bird.category, selectedTimeRange: $selectedTimeRange)
}
