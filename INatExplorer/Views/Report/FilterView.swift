//
//  FilterView.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 12/12/24.
//

import SwiftUI
import SwiftData

@available(*, deprecated)
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
    
    @Environment(\.modelContext) private var modelContext
    
    var filterSection: FilterSection
    
    @Query private var filters: [Filter]
    @State private var filterItems: [SelectableItem] = []
    
    var body: some View {
        Section {
            ForEach($filterItems, id: \.text) { $filterItem in
                SelectionView(selectionItem: $filterItem, onDelete: deleteItem)
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
        .onAppear() {
            switch filterSection {
            case .taxon:
                filterItems = filters.filter({ $0.filterType.section == .taxon })
            }
        }
    }
    
    private func deleteItem(itemToDelete: SelectableItem) {
        if let filterToRemove = itemToDelete as? Filter {
            modelContext.delete(filterToRemove)
        }
        
        if let index = filterItems.firstIndex(where: { $0.text == itemToDelete.text }) {
            filterItems.remove(at: index)
        }
    }
}

struct SelectionView: View {
    
    @Binding var selectionItem: SelectableItem
    var onDelete: (SelectableItem) -> Void
    
    var body: some View {
        HStack {
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
            
            Spacer()
            
            Button {
                onDelete(selectionItem)
            } label: {
                Image(systemName: "xmark")
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 1)
    }
}

#Preview {
    @Previewable @State var example: SelectableItem =
        Filter(filterType: .taxon(.Constants.greatHornedOwl), isSelected: false)
    
    FilterView(filterSection: .taxon)
    SelectionView(selectionItem: $example, onDelete: { _ in })
}
