//
//  Observation.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/4/24.
//

import Foundation

struct Observation: Identifiable {
    
    enum Constants {
        static let preview: Observation = .init(
            id: 252658676,
            name: "Barking Owl",
            observedTime: "2024-09-12T18:10:00+09:30",
            imageUrl: URL(string: "https://inaturalist-open-data.s3.amazonaws.com/photos/363572869/square.jpeg")!
        )
    }
    
    
    let id: Int
    let name: String
    let observedTime: String
    let imageUrl: URL?
}
