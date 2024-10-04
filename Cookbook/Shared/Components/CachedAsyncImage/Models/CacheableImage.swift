//
//  CacheableImage.swift
//  Cookbook
//
//  Created by Kyle Ronayne on 10/1/24.
//

import Foundation
import SwiftData

@Model 
class CacheableImage: UniqueModel {
    let url: String
    @Attribute(.externalStorage) let data: Data
    let modelIdentifier: String
    
    init(url: String, data: Data) {
        self.url = url
        self.data = data
        self.modelIdentifier = url
    }
}
