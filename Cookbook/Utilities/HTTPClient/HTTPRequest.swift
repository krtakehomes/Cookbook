//
//  HTTPRequest.swift
//  Cookbook
//
//  Created by Kyle Ronayne on 9/28/24.
//

import Foundation

/// A protocol defining the structure of an HTTP request.
protocol HTTPRequest {
    /// A dictionary representing HTTP request headers.
    typealias HTTPHeaders = [String: String]
    /// A dictionary representing query parameters for an HTTP request URL.
    typealias URLQueryParameters = [String: String]
    
    /// The HTTP method for the request.
    var method: HTTPMethod { get }
    
    /// The URL for the HTTP request.
    var url: String { get }
    
    /// The HTTP headers to include in the request.
    var headers: HTTPHeaders? { get }
    
    /// The query parameters to include in the HTTP request's URL.
    var urlQueryParameters: URLQueryParameters? { get }
    
    /// The body of the HTTP request.
    var body: HTTPRequestBody? { get }
}

/// An HTTP method.
enum HTTPMethod: String {
    case get = "GET"
}

/// An HTTP request body.
enum HTTPRequestBody {
    
    /// A JSON body.
    ///
    /// - Parameter dictionary: A dictionary representing the JSON.
    case json(dictionary: [String: Any])
}

extension HTTPRequest {
    
    /// Returns a `URLRequest` created from this HTTP request.
    ///
    /// - Throws: An ``HTTPClientError`` if the HTTP request could not be converted into a `URLRequest`.
    /// - Returns: A `URLRequest`.
    func toURLRequest() throws -> URLRequest {
        guard let url = URL(string: self.url) else {
            throw HTTPClientError.malformedRequestURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = self.method.rawValue
        urlRequest.allHTTPHeaderFields = self.headers ?? [:]
        
        if let urlQueryParameters = self.urlQueryParameters {
            urlRequest.appendURLQueryParameters(urlQueryParameters)
        }
        
        return urlRequest
    }
}

private extension URLRequest {
    
    /// Appends the provided URL query parameters to this HTTP request.
    ///
    /// - Parameter urlQueryParameters: The URL query parameters to append to this request.
    mutating func appendURLQueryParameters(_ urlQueryParameters: HTTPRequest.URLQueryParameters) {
        url?.append(queryItems: urlQueryParameters.map { URLQueryItem(name: $0.key, value: $0.value) })
    }
}
