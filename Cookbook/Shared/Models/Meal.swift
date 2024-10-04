//
//  Meal.swift
//  Cookbook
//
//  Created by Kyle Ronayne on 9/28/24.
//

import Foundation
import SwiftData

@Model
class Meal: UniqueModel {
    let id: String
    let name: String
    let category: MealCategory
    let imageURL: String
    
    var modelIdentifier: String {
        id
    }
    
    init(id: String, name: String, category: MealCategory, imageURL: String) {
        self.id = id
        self.name = name
        self.category = category
        self.imageURL = imageURL
    }
}
