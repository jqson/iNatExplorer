//
//  FilterSelectionView.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/12/24.
//

import SwiftUI

struct FilterView: View {
    
    enum FilterType {
        case taxon
        
        var title: String {
            switch self {
            case .taxon:
                "Species"
            }
        }
        
        var isMultipleSelection: Bool {
            switch self {
            case .taxon:
                true
            }
        }
    }
    
    @EnvironmentObject private var filterManager: FilterManager
    
    var filterType: FilterType
    
    @State private var filterItems: [SelectableItem] = []
    
    var body: some View {
        Section {
            List($filterItems, id: \.text) { $filterItem in
                SelectionView(selectionItem: $filterItem)
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 6, leading: 20, bottom: 6, trailing: 20))
                    .onChange(of: filterItem.isSelected) {
                        guard !filterType.isMultipleSelection, filterItem.isSelected else {
                            saveFilter()
                            return
                        }
                        
                        var skipSave = false
                        for index in filterItems.indices {
                            guard filterItems[index].text != filterItem.text else { continue }
                            if (filterItems[index].isSelected) {
                                skipSave = true
                                filterItems[index].isSelected = false
                            }
                        }
                        
                        if !skipSave {
                            saveFilter()
                        }
                    }
            }
            .scrollDisabled(true)
        } header: {
            Text(filterType.title)
                .font(.title2)
                .bold()
                .foregroundStyle(Color.accentColor)
                .padding(.leading, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .listStyle(.plain)
        .onAppear() {
            switch filterType {
            case .taxon:
                filterItems = filterManager.taxonFilter
            }
        }
    }
    
    private func saveFilter() {
        filterManager.taxonFilter = filterItems.compactMap { $0 as? SelectableTaxon }
    }
}

struct SelectionView: View {
    @Binding var selectionItem: SelectableItem
    
    var body: some View {
        Text(selectionItem.text)
            .font(.title3)
            .padding()
            .frame(height: 40)
            .foregroundStyle(selectionItem.isSelected ? Color.white : Color.accentColor)
            .background(
                selectionItem.isSelected ? Color.accentColor : Color(UIColor.systemBackground)
            )
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.accentColor, lineWidth: 1)
            )
            .onTapGesture {
                selectionItem.isSelected.toggle()
            }
    }
}

#Preview {
    FilterView(filterType: .taxon)
}
