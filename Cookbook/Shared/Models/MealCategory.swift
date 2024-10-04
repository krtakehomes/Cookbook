//
//  MealCategory.swift
//  Cookbook
//
//  Created by Kyle Ronayne on 9/29/24.
//

import Foundation
import SwiftData

@Model
class MealCategory: UniqueModel {
    let name: String
    
    var modelIdentifier: String {
        name
    }
    
    init(name: String) {
        self.name = name
    }
}
