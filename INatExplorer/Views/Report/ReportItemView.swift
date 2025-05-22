//
//  ReportItemView.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 12/4/24.
//

import SwiftUI

struct ReportItemView: View {
    
    enum Constants {
        static let imageSize: CGFloat = 100
    }
    
    var report: Report
    
    var body: some View {
        HStack {
            AsyncImage(url: report.photos.first?.getUrl(.small)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray
            }
            .frame(width: Constants.imageSize, height: Constants.imageSize)
            .clipped()
            
            
            VStack(alignment: .leading) {
                Text(report.name)
                Text(report.observedTime)
                if let description = report.description, !description.isEmpty {
                    Text("\"\(description)\"")
                        .lineLimit(2)
                        .italic()
                }
            }
        }
    }
}

#Preview {
    ReportItemView(report: Report.Constants.preview)
}
