//
//  Bookmark.swift
//  Cookbook
//
//  Created by Kyle Ronayne on 9/30/24.
//

import Foundation
import SwiftData

@Model
class Bookmark: UniqueModel {
    let mealID: String
    
    var modelIdentifier: String {
        mealID
    }
    
    init(mealID: String) {
        self.mealID = mealID
    }
}
