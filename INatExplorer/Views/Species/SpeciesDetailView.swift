//
//  SpeciesDetailView.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 12/20/24.
//

import Charts
import SwiftUI

struct SpeciesDetailView: View {
    
    var species: Species
    @StateObject var speciesItemViewModel: SpeciesItemViewModel
    
    @StateObject var taxonNamesViewModel = TaxonNamesViewModel()
    @StateObject var histogramViewModel = ReportHistogramViewModel()
    
    var body: some View {
        ScrollView {
            HStack {
                Text("\(species.name)\n\(taxonNamesViewModel.selectedTaxonName?.name ?? "-")")
                    .multilineTextAlignment(.leading)
                    .bold()
                    .padding(.horizontal)
                
                Spacer()
                
                NavigationLink {
                    ReportListView(taxons: [species.taxon])
                } label: {
                    Text("Observations")
                }
                .padding(.horizontal)
                .buttonStyle(.borderedProminent)
            }
            
            AsyncImage(url: species.photo?.getUrl(.medium)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Color.gray
            }
            .overlay(alignment: .topTrailing) {
                let isObserved = speciesItemViewModel.hasLabel(species: species, label: .observed)
                
                Button {
                    if isObserved {
                        speciesItemViewModel.removeLabel(species: species, label: .observed)
                    } else {
                        speciesItemViewModel.addLabel(species: species, label: .observed)
                    }
                } label: {
                    Image(systemName: SpeciesListView.Constants.observedIcon)
                        .resizable()
                        .scaledToFit()
                        .padding(4)
                        .shadow(color: .gray, radius: 2)
                }
                .frame(width: 35, height: 35)
                .tint(isObserved ? .orange : .gray)
            }
            
            let lastYearHistogram = histogramViewModel.lastYearHistogram
            let historicalHistogram = histogramViewModel.historicalHistogram
            let dateRange = histogramViewModel.dateRange
            
            Chart() {
                ForEach(historicalHistogram.counts, id: \.self) {
                    BarMark(
                        x: .value("Date", $0.date, unit: .weekOfYear),
                        y: .value("Count", $0.count),
                        width: .ratio(1.05)
                    )
                    .foregroundStyle(by: .value("Period", historicalHistogram.legend))
                }
                ForEach(lastYearHistogram.counts, id: \.self) {
                    BarMark(
                        x: .value("Date", $0.date, unit: .weekOfYear),
                        y: .value("Count", $0.count),
                        width: .ratio(0.4)
                    )
                    .foregroundStyle(by: .value("Period", lastYearHistogram.legend))
                    .position(by: .value("Period", lastYearHistogram.legend), axis: .horizontal, span: .ratio(1))
                }
            }
            .chartForegroundStyleScale([
                historicalHistogram.legend : Color.chartBarSecondary,
                lastYearHistogram.legend : Color.chartBarPrimary
            ])
            .chartXScale(domain: dateRange)
            .chartXAxis {
                AxisMarks(values: .stride(by: .month, count: 1)) { value in
                    AxisValueLabel(format: .dateTime.month())
                    AxisGridLine()
                    AxisTick()
                }
            }
            .chartYAxis {
                AxisMarks() {
                    AxisValueLabel().foregroundStyle(Color.chartBarPrimary)
                    AxisGridLine()
                }
            }
            .frame(height: 200)
            .padding(.horizontal)
            .padding(.top)
            
            let columns: [GridItem] = [
                GridItem(.fixed(120), alignment: .init(horizontal: .trailing, vertical: .top)),
                GridItem(.flexible(), alignment: .leading)
            ]
            
            let taxons: [Taxon] = species.ancestors + [species.taxon]
            
            LazyVGrid(columns: columns) {
                ForEach(taxons) { taxon in
                    Text("\(taxon.rank.rawValue.capitalized):")
                    Text(taxon.displayName)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .onAppear {
            Task {
                let taxonId = species.taxon.id
                
                async let loadTaxonNames: () = taxonNamesViewModel.fetchData(taxonId: taxonId)
                async let loadHistogram: () = histogramViewModel.fetchData(taxonId: taxonId)
                
                let _ = await [loadTaxonNames, loadHistogram]
            }
        }
    }
}

#Preview {
    SpeciesDetailView(
        species: Species.Constants.preview,
        speciesItemViewModel: SpeciesItemViewModel(dataService: .shared)
    )
}
