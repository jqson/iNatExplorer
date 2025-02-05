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
        ScrollView {
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
            
            let dateFormatter = DateFormatter()
            let _ = dateFormatter.dateFormat = "MM-dd"
            Chart(histogramViewModel.weeklyCounts, id: \.period) {
                BarMark(
                    x: .value("Date", $0.date, unit: .weekOfYear),
                    y: .value("Count", $0.count)
                )
                .foregroundStyle(by: .value("Period", $0.periodStr))
                .position(by: .value("Period", $0.periodStr), axis: .horizontal, span: .ratio(1))
            }
            .chartForegroundStyleScale([
                Histogram.Period.allYears.rawValue : .blue,
                Histogram.Period.lastYear.rawValue : .orange
            ])
            .chartXScale(domain: histogramViewModel.dateRange)
            .chartXAxis {
                AxisMarks(values: .stride(by: .month, count: 1)) { value in
                    AxisValueLabel(format: .dateTime.month())
                    AxisGridLine()
                    AxisTick()
                }
            }
            .chartYAxis {
                AxisMarks() {
                    AxisValueLabel().foregroundStyle(Color.orange)
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
            
            let classification: [Taxon] = species.ancestors + [species.taxon]
            
            LazyVGrid(columns: columns) {
                ForEach(classification) { taxon in
                    Text("\(taxon.rank.rawValue.capitalized):")
                    Text(taxon.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
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
