//
//  MealCategoriesResponse.swift
//  Cookbook
//
//  Created by Kyle Ronayne on 9/30/24.
//

import Foundation

struct MealCategoriesResponse: Decodable {
    let meals: [Meal]
    
    struct Meal: Decodable {
        let name: String
        
        private enum CodingKeys: String, CodingKey {
            case name = "strCategory"
        }
    }
}
