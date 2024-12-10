//
//  NetworkService.swift
//  MyNaturalist
//
//  Created by Yuanfeng Jiao on 12/6/24.
//

import Foundation

class NetworkService {
    
    enum NetworkError: Error {
        case badUrl
        case badResponse
        case badStatus
        case decodeError
    }
    
    enum ResponseCode: Int {
        case success = 200
    }
    
    static func sendRequest<T: Codable>(fromUrl: String) async throws -> T? {
        guard let url = URL(string: fromUrl) else {
            throw NetworkError.badUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.badResponse
        }
        
        guard response.statusCode == ResponseCode.success.rawValue else {
            throw NetworkError.badStatus
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let decodedResponse = try? decoder.decode(T.self, from: data) else {
            throw NetworkError.decodeError
        }
        
        return decodedResponse
    }
}
