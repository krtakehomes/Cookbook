//
//  CachedAsyncImageStatus.swift
//  Cookbook
//
//  Created by Kyle Ronayne on 10/1/24.
//

import Foundation

enum CachedAsyncImageStatus {
    case available(imageData: Data)
    case failed
    case loading
}
