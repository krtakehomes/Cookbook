//
//  MealDBRequest.swift
//  Cookbook
//
//  Created by Kyle Ronayne on 9/29/24.
//

import Foundation

enum MealDBRequest: HTTPRequest {
    case mealCategories
    case mealsByCategory(categoryName: String)
    case mealByID(mealID: String)
    case mealImage(url: String)
    
    var method: HTTPMethod { .get }
    
    var url: String {
        switch self {
            case .mealCategories:
                "https://www.themealdb.com/api/json/v1/1/list.php"
            case .mealsByCategory:
                "https://themealdb.com/api/json/v1/1/filter.php"
            case .mealByID:
                "https://themealdb.com/api/json/v1/1/lookup.php"
            case .mealImage(let url):
                url
        }
    }
    
    var headers: HTTPHeaders? { nil }
    
    var urlQueryParameters: URLQueryParameters? {
        switch self {
            case .mealCategories:
                ["c": "list"]
            case .mealsByCategory(let categoryName):
                ["c": categoryName]
            case .mealByID(let mealID):
                ["i": mealID]
            case .mealImage:
                nil
        }
    }
    
    var body: HTTPRequestBody? { nil }
}
