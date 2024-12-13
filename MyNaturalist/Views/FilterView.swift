//
//  FilterSelectionView.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/12/24.
//

import SwiftUI

protocol SelectableItem {
    var text: String { get }
    var selected: Bool { get set }
}

struct FilterView: View {
    @Binding var filterItems: [SelectableItem]
    
    var isMultipleSelection: Bool = false
    
    var body: some View {
        List($filterItems, id: \.text) { $filterItem in
            SelectionView(selectionItem: $filterItem)
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 5, leading: 20, bottom: 5, trailing: 20))
                .onChange(of: filterItem.selected) {
                    guard !isMultipleSelection, filterItem.selected else { return }
                    
                    for index in filterItems.indices {
                        guard filterItems[index].text != filterItem.text else { continue }
                        filterItems[index].selected = false
                    }
                }
        }
    }
}

struct SelectionView: View {
    @Binding var selectionItem: SelectableItem
    
    var body: some View {
        Text(selectionItem.text)
            .font(.title3)
            .cornerRadius(10)
            .padding()
            .foregroundStyle(selectionItem.selected ? Color.white : Color.accentColor)
            .background(selectionItem.selected ? Color.accentColor : Color.white)
            .border(Color.accentColor)
            .onTapGesture {
                selectionItem.selected.toggle()
            }
    }
}

#Preview {
    @Previewable @State var selections: [SelectableItem] = Taxon.allCases.map({ $0.info })
    
    FilterView(filterItems: $selections)
}
