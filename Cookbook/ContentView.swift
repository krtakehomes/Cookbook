//
//  ContentView.swift
//  Cookbook
//
//  Created by Kyle Ronayne on 10/3/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                MealCategoryList()
            }
            .tabItem {
                Label("Table of Contents", systemImage: "list.bullet")
            }
            
            NavigationStack {
                BookmarkList()
            }
            .tabItem {
                Label("Bookmarks", systemImage: "bookmark.fill")
            }
        }
    }
}

#Preview {
    ContentView()
}
