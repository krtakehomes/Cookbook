//
//  CookbookApp.swift
//  Cookbook
//
//  Created by Kyle Ronayne on 10/3/24.
//

import SwiftUI
import SwiftData

@main
struct CookbookApp: App {
    
    init() {
        SwiftDataService.shared.initializeContainer(for: MealCategory.self, Meal.self, MealDetail.self, Bookmark.self, CacheableImage.self)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
