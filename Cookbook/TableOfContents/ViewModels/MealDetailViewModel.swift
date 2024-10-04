//
//  MealDetailViewModel.swift
//  Cookbook
//
//  Created by Kyle Ronayne on 9/30/24.
//

import SwiftUI

class MealDetailViewModel: ObservableObject {
    
    @Published private var mealDetail: MealDetail?
    @Published private var isBookmarked = false
    @Published var showNoNetworkAlert = false
    private let meal: Meal
    private let httpClient: HTTPClient
    
    init(meal: Meal, httpClient: HTTPClient = HTTPService.shared) {
        self.meal = meal
        self.httpClient = httpClient
    }
    
    var imageURL: String {
        meal.imageURL
    }
    
    var bookmarkImageName: String {
        isBookmarked ? "bookmark.fill" : "bookmark"
    }
    
    var instructions: String {
        mealDetail?.instructions ?? ""
    }
    
    var ingredients: [MealIngredient] {
        mealDetail?.ingredients ?? []
    }
    
    @MainActor func fetchMealDetail() async {
        do {
            let response: MealByIDResponse = try await httpClient.request(MealDBRequest.mealByID(mealID: meal.id))
            
            guard let responseMeal = response.meals.first else {
                return
            }
            
            let newMealDetail = MealDetail(mealID: responseMeal.mealId,
                                           name: responseMeal.name,
                                           imageURL: responseMeal.imageURL,
                                           category: responseMeal.category,
                                           origin: responseMeal.origin,
                                           instructions: responseMeal.instructions,
                                           ingredients: zip(responseMeal.ingredients, responseMeal.measurements)
                                                            .map { MealIngredient(name: $0.0, measurement: $0.1) }
                                                            .filter { !$0.name.isEmpty && !$0.measurement.isEmpty })
            showNoNetworkAlert = false
            mealDetail = newMealDetail
            cacheMealDetail(newMealDetail)
        } catch {
            print(error)
            mealDetail = fetchCachedMealDetail()
            showNoNetworkAlert = mealDetail == nil
        }
    }
    
    @MainActor func fetchBookmarkStatus() {
        do {
            isBookmarked = try SwiftDataService.shared.read(Bookmark.self, withIdentifier: self.meal.id) != nil
        } catch {
            print(error)
        }
    }
    
    @MainActor func toggleBookmarkStatus() {
        isBookmarked.toggle()
        
        do {
            if isBookmarked {
                try SwiftDataService.shared.create(Bookmark(mealID: meal.id))
            } else {
                try SwiftDataService.shared.delete(Bookmark.self, withIdentifier: meal.id)
            }
        } catch {
            print(error)
        }
    }
    
    @MainActor private func cacheMealDetail(_ mealDetail: MealDetail) {
        do {
            try SwiftDataService.shared.create(mealDetail)
        } catch {
            print(error)
        }
    }
    
    @MainActor private func fetchCachedMealDetail() -> MealDetail? {
        do {
            return try SwiftDataService.shared.read(MealDetail.self, withIdentifier: meal.modelIdentifier)
        } catch {
            print(error)
            return nil
        }
    }
}
