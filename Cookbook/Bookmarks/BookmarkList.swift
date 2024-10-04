//
//  BookmarkList.swift
//  Cookbook
//
//  Created by Kyle Ronayne on 9/30/24.
//

import SwiftUI

struct BookmarkList: View {
    
    @StateObject private var viewModel = BookmarkListViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.mealsByCategory.keys.sorted(by: { $0.name < $1.name })) { category in
                if let meals = viewModel.mealsByCategory[category] {
                    Section(header: Text(category.name)) {
                        ForEach(meals) { meal in
                            NavigationLink(value: meal) {
                                HStack {
                                    CachedAsyncImage(url: meal.imageURL) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxHeight: 100)
                                    }
                                    
                                    Text(meal.name)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Bookmarks")
        .navigationDestination(for: Meal.self) {
            MealDetailView(meal: $0)
                .toolbar(.hidden, for: .tabBar)
        }
        .task {
            await viewModel.fetchBookmarks()
        }
        .overlay {
            if viewModel.showNoBookmarksMessage {
                Text("Your bookmarked meals will appear here")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
    }
}
