//
//  FilterView.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/12/24.
//

import SwiftUI
import SwiftData

struct FilterView: View {
    
    enum FilterSection {
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
    
    @Environment(\.modelContext) var modelContext
    
    var filterSection: FilterSection
    
    @Query private var filters: [Filter]
    @State private var filterItems: [SelectableItem] = []
    
    var body: some View {
        Section {
            ForEach($filterItems, id: \.text) { $filterItem in
                SelectionView(selectionItem: $filterItem)
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 6, leading: 20, bottom: 6, trailing: 20))
                    .onChange(of: filterItem.isSelected) {
                        guard !filterSection.isMultipleSelection, filterItem.isSelected else {
                            return
                        }
                        
                        for index in filterItems.indices {
                            guard filterItems[index].text != filterItem.text else { continue }
                            if (filterItems[index].isSelected) {
                                filterItems[index].isSelected = false
                            }
                        }
                    }
            }
        } header: {
            Text(filterSection.title)
                .font(.title2)
                .bold()
                .foregroundStyle(Color.accentColor)
                .padding(.leading, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .listStyle(.plain)
        .onAppear() {
            switch filterSection {
            case .taxon:
                filterItems = filters.filter({ $0.filterType.section == .taxon })
            }
        }
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
    FilterView(filterSection: .taxon)
}
