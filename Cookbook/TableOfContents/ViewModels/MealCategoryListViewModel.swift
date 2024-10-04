//
//  MealCategoryListViewModel.swift
//  Cookbook
//
//  Created by Kyle Ronayne on 9/30/24.
//

import Foundation

class MealCategoryListViewModel: ObservableObject {
    
    @Published private(set) var categories: [String: [MealCategory]] = [:]
    @Published private(set) var showNoNetworkMessage = false
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient = HTTPService.shared) {
        self.httpClient = httpClient
    }
    
    @MainActor func fetchCategories() async {
        do {
            let response: MealCategoriesResponse = try await httpClient.request(MealDBRequest.mealCategories)
            let sortedCategories = response.meals.map { MealCategory(name: $0.name)}.sorted(by: { $0.name < $1.name })
            
            showNoNetworkMessage = false
            categories = groupCategoriesByFirstLetter(sortedCategories)
            cacheCategories(sortedCategories)
        } catch {
            print(error)
            categories = groupCategoriesByFirstLetter(fetchCachedCategories())
            showNoNetworkMessage = categories.isEmpty
        }
    }
    
    private func groupCategoriesByFirstLetter(_ categories: [MealCategory]) -> [String: [MealCategory]] {
        Dictionary(grouping: categories.filter { !$0.name.isEmpty }, by: { category in
            String(category.name.first!)
        })
    }
    
    @MainActor private func cacheCategories(_ categories: [MealCategory]) {
        do {
            try categories.forEach {
                try SwiftDataService.shared.create($0)
            }
        } catch {
            print(error)
        }
    }
    
    @MainActor private func fetchCachedCategories() -> [MealCategory] {
        do {
            return try SwiftDataService.shared.readAll(MealCategory.self)
        } catch {
            print(error)
            return []
        }
    }
}
