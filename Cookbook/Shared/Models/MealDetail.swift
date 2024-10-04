//
//  MealDetail.swift
//  Cookbook
//
//  Created by Kyle Ronayne on 9/30/24.
//

import Foundation
import SwiftData

@Model
class MealDetail: UniqueModel {
    let mealID: String
    let name: String
    let imageURL: String
    let category: String
    let origin: String
    let instructions: String
    let ingredients: [MealIngredient]
    
    var modelIdentifier: String {
        mealID
    }
    
    init(mealID: String, name: String, imageURL: String, category: String, origin: String, instructions: String, ingredients: [MealIngredient]) {
        self.mealID = mealID
        self.name = name
        self.imageURL = imageURL
        self.category = category
        self.origin = origin
        self.instructions = instructions
        self.ingredients = ingredients
    }
}
