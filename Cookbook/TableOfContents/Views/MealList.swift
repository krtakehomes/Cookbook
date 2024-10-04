//
//  MealList.swift
//  Cookbook
//
//  Created by Kyle Ronayne on 9/28/24.
//

import SwiftUI

struct MealList: View {
    
    @StateObject private var viewModel = MealListViewModel()
    let category: MealCategory
    
    var body: some View {
        List(viewModel.meals) { meal in
            NavigationLink(value: meal, label: {
                HStack {
                    CachedAsyncImage(url: meal.imageURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    }
                    .frame(width: 100, height: 100)
                    
                    Text(meal.name)
                }
            })
        }
        .navigationDestination(for: Meal.self) {
            MealDetailView(meal: $0)
        }
        .navigationTitle(category.name)
        .task {
            if viewModel.meals.isEmpty {
                await viewModel.fetchMeals(by: category)
            }
        }
        .refreshable {
            await viewModel.fetchMeals(by: category)
        }
        .overlay {
            if viewModel.showNoNetworkMessage {
                Text("Unable to load meals. Please check your network connection and try again.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
    }
}

//#Preview {
//    DessertsTab()
//}
