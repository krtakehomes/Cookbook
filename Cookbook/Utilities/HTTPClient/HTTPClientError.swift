//
//  HTTPClientError.swift
//  Cookbook
//
//  Created by Kyle Ronayne on 9/28/24.
//

import Foundation

/// A generic error that can be thrown by any ``HTTPClient``.
enum HTTPClientError: Error {
    /// An indication that the HTTP request URL was not properly formatted.
    case malformedRequestURL
    
    /// An indication that the HTTP response body could not be decoded.
    ///
    /// - Parameters:
    ///   - httpRequest: The HTTP request of the response body.
    ///   - decodingError: The decoding error that occurred.
    ///   - decodableType: The expected decodable type of the HTTP response.
    case responseBodyNotDecodable(httpRequest: HTTPRequest, decodingError: DecodingError, decodableType: Decodable.Type)
    
    /// Detailed information about this error.
    var description: String {
        switch self {
            case .malformedRequestURL:
                return "*** HTTP Client Error: \(self) ***"
            case .responseBodyNotDecodable(let httpRequest, let decodingError, let decodableType):
                return """
                *** HTTP Client Error: responseNotDecodable
                - Request URL: \(httpRequest.url)
                - Decoding Error: \(decodingError)
                - Desired Decodable Type: \(String(describing: decodableType))
                ***
                """
        }
    }
}
