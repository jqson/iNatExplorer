//
//  ReportDetailView.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 12/9/24.
//

import SwiftUI

struct ReportDetailView: View {
    
    var report: Report
    @StateObject var locationViewModel = LocationViewModel()
    @StateObject var taxonNamesViewModel = TaxonNamesViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Text("\(report.name)\n\(taxonNamesViewModel.selectedTaxonName?.name ?? "-")")
                    .padding(.leading)
                    .bold()
                
                Spacer()
                
                UpdateFilterButtonView(taxon: report.taxon)
            }
            .padding()
            
            ScrollView {
                Text(report.observedTime)
                
                Text(locationViewModel.location?.displayAddress ?? "Failed to get address")
                
                if let description = report.description, !description.isEmpty {
                    Text("\"\(description)\"")
                        .italic()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                }
                
                if let link = report.webLink {
                    Link("inaturalist.org", destination: link)
                }
                
                ForEach(report.photos, id: \.id) { photo in
                    AsyncImage(url: photo.getUrl(.medium)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Color.gray
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                }
                .listRowSpacing(5)
                .listStyle(PlainListStyle())
            }
        }
        .onAppear {
            Task {
                async let loadLocation: () = locationViewModel.fetchData(coordinates: report.coordinates)
                
                if let taxonId = report.taxon?.id {
                    async let loadTaxonNames: () = taxonNamesViewModel.fetchData(taxonId: taxonId)
                    let _ = await [loadLocation, loadTaxonNames]
                } else {
                    await loadLocation
                }
            }
        }
    }
}

#Preview {
    ReportDetailView(report: Report.Constants.preview)
}
