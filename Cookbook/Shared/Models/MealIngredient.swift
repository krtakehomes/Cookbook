//
//  MealIngredient.swift
//  Cookbook
//
//  Created by Kyle Ronayne on 10/1/24.
//

import Foundation

struct MealIngredient: Codable, Hashable {
    let name: String
    let measurement: String
    
    init(name: String, measurement: String) {
        self.name = name
        self.measurement = measurement
    }
}
