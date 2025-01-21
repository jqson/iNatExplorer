//
//  ReportListView.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/4/24.
//

import SwiftUI

struct ReportListView: View {
    
    @StateObject private var reportViewModel = ReportViewModel()
    @State private var reports: [Report] = []
    @State private var isLoading = true
    
    @EnvironmentObject private var filterManager: FilterManager
    
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
                
                let taxons = filterManager.taxonFilter.filter({ $0.isSelected }).map({ $0.taxon })
                
                await reportViewModel.fetchData(taxons: taxons)
                reports = reportViewModel.reports
                isLoading = false
            }
        }
    }
}

#Preview {
    ReportListView()
        .environmentObject(FilterManager())
}
