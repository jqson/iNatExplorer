//
//  ItemView.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/4/24.
//

import SwiftUI

struct ItemView: View {
    
    enum Constants {
        static let imageSize: CGFloat = 100
    }
    
    var observation: Observation
    
    var body: some View {
        HStack {
            AsyncImage(url: observation.imageUrl) { image in
                image.image?.resizable()
            }
            .frame(width: Constants.imageSize, height: Constants.imageSize)
            
            VStack(alignment: .leading) {
                Text(observation.name)
                Text(observation.observedTime)
            }
        }
    }
}

#Preview {
    ItemView(observation: Observation.Constants.preview)
}
