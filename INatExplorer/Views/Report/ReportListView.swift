//
//  ReportListView.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 12/4/24.
//

import SwiftUI
import SwiftData

struct ReportListView: View {
    
    var taxons: [Taxon]
    
    @State private var reportViewModel = ReportViewModel()
    @State private var reports: [Report] = []
    @State private var isLoading = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                List(reports) { report in
                    NavigationLink(destination: ReportDetailView(report: report)) {
                        ReportItemView(report: report)
                    }
                    .navigationTitle("Observations")
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
                
                await reportViewModel.fetchData(taxons: taxons)
                reports = reportViewModel.reports
                isLoading = false
            }
        }
    }
}

#Preview {
    ReportListView(taxons: [Taxon.Constants.greatHornedOwl])
}
