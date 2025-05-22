//
//  ReportListView.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 12/4/24.
//

import SwiftUI
import SwiftData

struct ReportListView: View {
    
    @StateObject private var reportViewModel = ReportViewModel()
    @State private var reports: [Report] = []
    @State private var isLoading = true
    
    @Query private var filters: [Filter]
    
    var body: some View {
        NavigationStack {
            ZStack {
                List(reports) { report in
                    NavigationLink(destination: ReportDetailView(report: report)) {
                        ReportItemView(report: report)
                    }
                    .navigationTitle("Search Results")
                }
                .listStyle(.plain)
                
                ZStack {
                    Color(UIColor.systemBackground)
                        .edgesIgnoringSafeArea(.all)
                    ProgressView()
                        .scaleEffect(2)
                }
                .opacity(isLoading ? 1 : 0)
            }
            .task {
                guard isLoading else { return }
                
                let taxons: [Taxon] = filters.compactMap {
                    guard case .taxon(let taxon) = $0.filterType, $0.isSelected else { return nil }
                    
                    return taxon
                }
                
                await reportViewModel.fetchData(taxons: taxons)
                reports = reportViewModel.reports
                isLoading = false
            }
        }
    }
}

#Preview {
    ReportListView()
}
