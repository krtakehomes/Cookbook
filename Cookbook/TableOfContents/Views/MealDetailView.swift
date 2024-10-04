//
//  MealDetailView.swift
//  Cookbook
//
//  Created by Kyle Ronayne on 9/30/24.
//

import SwiftUI
import SwiftData

struct MealDetailView: View {
    
    @StateObject private var viewModel: MealDetailViewModel
    @Environment(\.dismiss) private var dismissAction
    private let meal: Meal
    
    init(meal: Meal) {
        self._viewModel = StateObject(wrappedValue: MealDetailViewModel(meal: meal))
        self.meal = meal
    }
    
    var body: some View {
        ScrollView {
            VStack {
                CachedAsyncImage(url: viewModel.imageURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 250, alignment: .center)
                            .clipped()
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 8) {
                        Text(meal.name)
                            .font(.largeTitle.weight(.bold))
                            .multilineTextAlignment(.center)
                        
                        Button(action: { viewModel.toggleBookmarkStatus() }) {
                            Image(systemName: viewModel.bookmarkImageName)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Instructions")
                            .font(.title2.weight(.semibold))
                        
                        Text(viewModel.instructions)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Ingredients")
                            .font(.title2.weight(.semibold))
                        
                        VStack(spacing: 4) {
                            ForEach(viewModel.ingredients, id: \.self) { ingredient in
                                HStack {
                                    Text(ingredient.name)
                                    
                                    Spacer()
                                    
                                    Text(ingredient.measurement)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchMealDetail()
            viewModel.fetchBookmarkStatus()
        }
        .alert("Unable to load meal details. Please check your network connection and try again", isPresented: $viewModel.showNoNetworkAlert) {
            Button("OK", role: .cancel) { 
                dismissAction()
            }
        }
    }
}

//#Preview {
//    MealDetailView()
//}
