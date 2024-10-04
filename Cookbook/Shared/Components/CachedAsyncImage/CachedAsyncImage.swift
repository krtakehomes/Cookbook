//
//  CachedAsyncImage.swift
//  Cookbook
//
//  Created by Kyle Ronayne on 10/1/24.
//

import SwiftUI

struct CachedAsyncImage<T: View, U: View, V: View>: View {
    
    @StateObject private var viewModel: CachedAsyncImageViewModel
    private let image: (Image) -> T
    private let loadingStatusView: U
    private let failedStatusView: V
    
    init(url: String,
         @ViewBuilder image: @escaping (Image) -> T,
         @ViewBuilder loadingStatusView: () -> U = { ProgressView() },
         @ViewBuilder failedStatusView: () -> V = { Image(systemName: "xmark.octagon") }) {
        self._viewModel = StateObject(wrappedValue: CachedAsyncImageViewModel(url: url))
        self.loadingStatusView = loadingStatusView()
        self.failedStatusView = failedStatusView()
        self.image = image
    }
    
    var body: some View {
        VStack {
            switch viewModel.status {
                case .available(let imageData):
                    if let uiImage = UIImage(data: imageData) {
                        image(Image(uiImage: uiImage))
                    } else {
                        failedStatusView
                    }
                case .failed:
                    failedStatusView
                case .loading:
                    loadingStatusView
            }
        }
        .task {
            await viewModel.fetchImage()
        }
    }
}
