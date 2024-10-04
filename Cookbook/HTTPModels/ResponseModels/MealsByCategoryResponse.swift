//
//  MealsByCategoryResponse.swift
//  Cookbook
//
//  Created by Kyle Ronayne on 9/29/24.
//

import Foundation

struct MealsByCategoryResponse: Decodable {
    let meals: [Meal]
    
    struct Meal: Decodable {
        let id: String
        let name: String
        let imageURL: String
        
        private enum CodingKeys: String, CodingKey {
            case id = "idMeal"
            case name = "strMeal"
            case imageURL = "strMealThumb"
        }
    }
}
