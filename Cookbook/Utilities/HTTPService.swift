//
//  HTTPService.swift
//  Cookbook
//
//  Created by Kyle Ronayne on 9/29/24.
//

import Foundation

class HTTPService: HTTPClient {
    
    static let shared = HTTPService()
    
    func request<T: Decodable>(_ httpRequest: HTTPRequest) async throws -> T {
        do {
            let urlRequest = try httpRequest.toURLRequest()
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch let error as DecodingError {
                throw HTTPClientError.responseBodyNotDecodable(httpRequest: httpRequest, decodingError: error, decodableType: T.self)
            }
        } catch let error as HTTPClientError {
            print(error.description)
            throw error
        }
    }
    
    func request(_ url: URL) async throws -> Data {
        do {
            let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
            return data
        } catch let error as HTTPClientError {
            print(error.description)
            throw error
        }
    }
}
