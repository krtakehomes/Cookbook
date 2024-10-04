//
//  CachedAsyncImageViewModel.swift
//  Cookbook
//
//  Created by Kyle Ronayne on 10/1/24.
//

import Foundation

class CachedAsyncImageViewModel: ObservableObject {
    
    @Published private(set) var status: CachedAsyncImageStatus = .loading
    private let url: String
    
    init(url: String) {
        self.url = url
    }
    
    @MainActor func fetchImage() async {
        do {
            if let cachedImage = try SwiftDataService.shared.read(CacheableImage.self, withIdentifier: url) {
                status = .available(imageData: cachedImage.data)
            } else {
                guard let url = URL(string: url) else {
                    status = .failed
                    return
                }
                
                let fetchedImageData = try await HTTPService.shared.request(url)
                try SwiftDataService.shared.create(CacheableImage(url: self.url, data: fetchedImageData))
                status = .available(imageData: fetchedImageData)
            }
        } catch {
            print(error)
            status = .failed
        }
    }
}
