//
//  SpeciesDetailView.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/20/24.
//

import Charts
import SwiftUI

struct SpeciesDetailView: View {
    
    var species: Species
    @StateObject var taxonNamesViewModel = TaxonNamesViewModel()
    @StateObject var histogramViewModel = ReportHistogramViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Text("\(species.name)\n\(taxonNamesViewModel.selectedTaxonName?.name ?? "-")")
                    .padding(.leading)
                    .bold()
                
                Spacer()
                
                UpdateFilterButtonView(taxon: species.taxon)
            }
            .padding(.horizontal)
            
            AsyncImage(url: species.photo?.getUrl(.medium)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Color.gray
            }
            
            let columns: [GridItem] = [
                GridItem(.fixed(120), alignment: .init(horizontal: .trailing, vertical: .top)),
                GridItem(.flexible(), alignment: .leading)
            ]
            
            let classification: [Taxon] = species.ancestors + [species.taxon]
            
            LazyVGrid(columns: columns) {
                ForEach(classification) { taxon in
                    Text("\(taxon.rank.rawValue.capitalized):")
                    Text(taxon.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            
            Chart {
                ForEach(histogramViewModel.weeklyCounts, id: \.period) {
                    BarMark(
                        x: .value("Date", $0.label),
                        y: .value("Count", $0.count)
                    )
                    .foregroundStyle(by: .value("Period", $0.periodStr))
                    .position(by: .value("Period", $0.periodStr), span: .ratio(1))
                }
            }
            .frame(height: 200)
        }
        .onAppear {
            Task {
                async let loadTaxonNames: () = taxonNamesViewModel.fetchData(taxonId: species.taxon.id)
                async let loadHistogram: () = histogramViewModel.fetchData(taxonId: species.taxon.id)
                
                let _ = await [loadTaxonNames, loadHistogram]
            }
        }
    }
}

#Preview {
    SpeciesDetailView(species: Species.Constants.preview)
}
