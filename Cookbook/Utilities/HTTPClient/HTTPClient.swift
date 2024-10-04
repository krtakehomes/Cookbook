//
//  HTTPClient.swift
//  Cookbook
//
//  Created by Kyle Ronayne on 9/28/24.
//

import Foundation

/// A utility for performing HTTP requests.
protocol HTTPClient {
    /// Performs the provided HTTP request and returns its response as the specified decodable type.
    ///
    /// - Parameter httpRequest: The HTTP request to execute.
    /// - Returns: The HTTP request's response as the specified decodable type.
    /// - Throws: An ``HTTPClientError`` if the HTTP request failed.
    func request<T: Decodable>(_ httpRequest: HTTPRequest) async throws -> T
    
    func request(_ httpRequest: HTTPRequest) async throws -> Data
}
