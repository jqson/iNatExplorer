//
//  FilterSelectionView.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/12/24.
//

import SwiftUI

protocol SelectableItem {
    var text: String { get }
    var isSelected: Bool { get set }
}

struct FilterView: View {
    @Binding var filterItems: [SelectableItem]
    
    var filterTitle: String?
    var isMultipleSelection: Bool = false
    
    var body: some View {
        Section {
            List($filterItems, id: \.text) { $filterItem in
                SelectionView(selectionItem: $filterItem)
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 6, leading: 20, bottom: 6, trailing: 20))
                    .onChange(of: filterItem.isSelected) {
                        guard !isMultipleSelection, filterItem.isSelected else { return }
                        
                        for index in filterItems.indices {
                            guard filterItems[index].text != filterItem.text else { continue }
                            filterItems[index].isSelected = false
                        }
                    }
            }
            .scrollDisabled(true)
        } header: {
            if let title = filterTitle {
                Text(title)
                    .font(.title2)
                    .bold()
                    .foregroundStyle(Color.accentColor)
                    .padding(.leading, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .listStyle(.plain)
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
    @Previewable @State var selections: [SelectableItem] = [
        SelectableTaxon(taxon: Taxon.Constants.greatHornedOwl),
        SelectableTaxon(taxon: Taxon.Constants.shortEaredOwl),
        SelectableTaxon(taxon: Taxon.Constants.americanBarnOwl),
    ]
    
    FilterView(filterItems: $selections, filterTitle: "Species")
}
