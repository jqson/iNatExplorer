//
//  CategorySelectionView.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 12/27/24.
//

import SwiftUI

struct TimeRangePickerView: View {
    
    @Binding var selectedTimeRange: DateUtil.TimeRange
    
    var body: some View {
        Picker("Time Range", selection: $selectedTimeRange) {
            ForEach(DateUtil.TimeRange.allCases) { timeRange in
                Text("Past " + timeRange.rawValue.capitalized(with: .current))
            }
        }
        .padding()
        .pickerStyle(.segmented)
    }
}

struct CategorySelectionView: View {
    
    @AppStorage(UserDefaultsKeys.speciesTimeRange)
    private var selectedTimeRange: DateUtil.TimeRange = .year
    
    private let categories: [CategoryStruct] = Category.allCases.map { $0.category }
    
    var body: some View {
        NavigationStack {
            VStack {
                TimeRangePickerView(selectedTimeRange: $selectedTimeRange)
                
                Spacer()
                
                ForEach(categories) { category in
                    NavigationLink(
                        destination: SpeciesListView(
                            category: category, selectedTimeRange: $selectedTimeRange
                        )
                    ) {
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
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    CategorySelectionView()
}
