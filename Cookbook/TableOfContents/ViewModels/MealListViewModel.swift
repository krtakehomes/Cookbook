//
//  MealListViewModel.swift
//  Cookbook
//
//  Created by Kyle Ronayne on 9/29/24.
//

import Foundation

class MealListViewModel: ObservableObject {
    
    @Published private(set) var meals: [Meal] = []
    @Published private(set) var showNoNetworkMessage = false
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient = HTTPService.shared) {
        self.httpClient = httpClient
    }
    
    @MainActor func fetchMeals(by category: MealCategory) async {
        do {
            let response: MealsByCategoryResponse = try await httpClient.request(MealDBRequest.mealsByCategory(categoryName: category.name))
            let sortedMeals = response.meals
                .map { Meal(id: $0.id, name: $0.name, category: category, imageURL: $0.imageURL)}
                .sorted(by: { $0.name < $1.name })
            
            showNoNetworkMessage = false
            meals = sortedMeals
            cacheMeals(meals)
        } catch {
            print(error)
            meals = fetchCachedMeals(by: category)
            showNoNetworkMessage = meals.isEmpty
        }
    }
    
    @MainActor private func cacheMeals(_ meals: [Meal]) {
        do {
            try meals.forEach {
                try SwiftDataService.shared.create($0)
            }
        } catch {
            print(error)
        }
    }
    
    @MainActor private func fetchCachedMeals(by category: MealCategory) -> [Meal] {
        do {
            let allCachedMeals = try SwiftDataService.shared.readAll(Meal.self)
            return allCachedMeals.filter { $0.category == category }
        } catch {
            print(error)
            return []
        }
    }
}
