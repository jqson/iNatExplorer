//
//  Species.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/19/24.
//

import Foundation

struct Species: Identifiable {
    
    enum Constants {
        static let preview: Species = .init(
            id: 6317,
            name: "Anna's Hummingbird",
            photo: .init(id: 256649705, urlStr: "https://static.inaturalist.org/photos/256649705/square.jpg")
        )
    }
    
    let id: Int
    let name: String
    let photo: CdnImage?
}
