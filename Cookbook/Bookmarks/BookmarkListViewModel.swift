//
//  BookmarkListViewModel.swift
//  Cookbook
//
//  Created by Kyle Ronayne on 10/1/24.
//

import Foundation

class BookmarkListViewModel: ObservableObject {
    
    @Published private(set) var mealsByCategory: [MealCategory: [Meal]] = [:]
    
    var showNoBookmarksMessage: Bool {
        mealsByCategory.isEmpty
    }
    
    @MainActor func fetchBookmarks() async {
        do {
            let savedBookmarkIDs = try SwiftDataService.shared.readAll(Bookmark.self).map { $0.mealID }
            let savedMeals = try SwiftDataService.shared.readAll(Meal.self)
            let bookmarkedMeals = savedMeals.filter { savedBookmarkIDs.contains($0.id) }
            
            mealsByCategory = categorizeMeals(meals: bookmarkedMeals)
        } catch {
            print(error)
        }
    }
    
    private func categorizeMeals(meals: [Meal]) -> [MealCategory: [Meal]] {
        let mealsByCategory = Dictionary(grouping: meals) { $0.category }
        let sortedMealsByCategory = mealsByCategory.mapValues {
            $0.sorted { $0.name < $1.name }
        }
        
        return sortedMealsByCategory
    }
}
