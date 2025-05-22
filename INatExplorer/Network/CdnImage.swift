//
//  CdnImage.swift
//  INatExplorer
//
//  Created by Yuanfeng Jiao on 12/10/24.
//

import Foundation

struct CdnImage {
    
    enum ImageSize: String {
        case square
        case thumb
        case small
        case medium
        case large
        case original
    }
    
    let id: Int
    let baseUrl: URL
    let fileExtension: String
    
    init?(photoResponse: PhotoResponse) {
        self.init(id: photoResponse.id, urlStr: photoResponse.url)
    }
    
    init?(id: Int, urlStr: String) {
        self.id = id
        
        guard let url = URL(string: urlStr) else { return nil }
        
        baseUrl = url.deletingLastPathComponent()
        fileExtension = url.pathExtension
    }
    
    func getUrl(_ size: ImageSize) -> URL {
        return baseUrl.appendingPathComponent("\(size.rawValue).\(fileExtension)")
    }
}
