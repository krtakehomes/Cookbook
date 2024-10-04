//
//  MealByIDResponse.swift
//  Cookbook
//
//  Created by Kyle Ronayne on 9/29/24.
//

import Foundation

struct MealByIDResponse: Decodable {
    let meals: [Meal]
    
    struct Meal: Decodable {
        let mealId: String
        let name: String
        let imageURL: String
        let category: String
        let origin: String
        let instructions: String
        let ingredients: [String]
        let measurements: [String]
        let source: String?
        
        private enum CodingKeys: String, CodingKey {
            case mealId = "idMeal"
            case name = "strMeal"
            case imageURL = "strMealThumb"
            case category = "strCategory"
            case origin = "strArea"
            case instructions = "strInstructions"
            case source = "strSource"
        }
        
        private struct RecipeDynamicCodingKey: CodingKey {
            var stringValue: String
            var intValue: Int?
            
            init?(stringValue: String) {
                self.stringValue = stringValue
            }
            
            init?(intValue: Int) {
                self.intValue = intValue
                self.stringValue = "\(intValue)"
            }
        }
        
        init(from decoder: Decoder) throws {
            let staticContainer = try decoder.container(keyedBy: CodingKeys.self)
            self.mealId = try staticContainer.decode(String.self, forKey: .mealId)
            self.name = try staticContainer.decode(String.self, forKey: .name)
            self.imageURL = try staticContainer.decode(String.self, forKey: .imageURL)
            self.category = try staticContainer.decode(String.self, forKey: .category)
            self.origin = try staticContainer.decode(String.self, forKey: .origin)
            self.instructions = try staticContainer.decode(String.self, forKey: .instructions)
            self.source = try staticContainer.decodeIfPresent(String.self, forKey: .source)
            
            let dynamicContainer = try decoder.container(keyedBy: RecipeDynamicCodingKey.self)
            self.ingredients = dynamicContainer.allKeys
                .filter { $0.stringValue.starts(with: "strIngredient") }
                .sorted(by: { $0.stringValue < $1.stringValue })
                .compactMap { try? dynamicContainer.decode(String.self, forKey: $0) }
            self.measurements = dynamicContainer.allKeys
                .filter { $0.stringValue.starts(with: "strMeasure") }
                .sorted(by: { $0.stringValue < $1.stringValue })
                .compactMap { try? dynamicContainer.decode(String.self, forKey: $0) }
        }
    }
}
