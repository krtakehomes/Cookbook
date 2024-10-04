//
//  MealCategoryList.swift
//  Cookbook
//
//  Created by Kyle Ronayne on 9/30/24.
//

import SwiftUI

struct MealCategoryList: View {
    
    @StateObject private var viewModel = MealCategoryListViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.categories.keys.sorted(by: { $0 < $1 }), id: \.self) { firstLetter in
                if let categories = viewModel.categories[firstLetter] {
                    Section(header: Text(firstLetter)) {
                        ForEach(categories.sorted(by: { $0.name < $1.name })) { category in
                            NavigationLink(value: category, label: {
                                Text(category.name)
                            })
                        }
                    }
                }
            }
        }
        .navigationTitle("Table of Contents")
        .navigationDestination(for: MealCategory.self) {
            MealList(category: $0)
                .toolbar(.hidden, for: .tabBar)
        }
        .task {
            if viewModel.categories.isEmpty {
                await viewModel.fetchCategories()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            Task {
                await viewModel.fetchCategories()
            }
        }
        .refreshable {
            await viewModel.fetchCategories()
        }
        .overlay {
            if viewModel.showNoNetworkMessage {
                Text("Unable to load cookbook. Please check your network connection and try again.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    MealCategoryList()
}
