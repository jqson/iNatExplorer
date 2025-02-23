//
//  AosFamilyOrder.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 2/22/25.
//

import Foundation


class AosFamilyOrder {
    
    enum Constants {
        static let fileName: String = "aos_family_order"
        static let fileExtension: String = "txt"
    }
    
    static let shared = AosFamilyOrder()
    
    private(set) var familyOrder: [String: Int] = [:]
    
    private init() {
        guard
            let fileUrl = Bundle.main.url(
                forResource: Constants.fileName, withExtension: Constants.fileExtension
            )
        else {
            return
        }
        
        do {
            let fileContent = try String(contentsOf: fileUrl, encoding: .utf8)
            let lines = fileContent.split(separator: "\n")
            for (idx, line) in lines.enumerated() {
                familyOrder[String(line)] = idx
            }
        } catch {
            return
        }
    }
}
