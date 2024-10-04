//
//  SwiftDataService.swift
//  Cookbook
//
//  Created by Kyle Ronayne on 9/30/24.
//

import Foundation
import SwiftData

class SwiftDataService {
    
    @MainActor static let shared = SwiftDataService()
    private var modelContext: ModelContext!
    
    /// Initializes the app’s SwiftData schema and model storage configuration.
    ///
    /// - Parameter models: The SwiftData models to include in the container.
    /// - Important: This function must be called at app initialization.
    @MainActor func initializeContainer(for models: any PersistentModel.Type...) {
        let modelContainer = try! ModelContainer(for: Schema(models))
        self.modelContext = modelContainer.mainContext
    }
    
    func create<T>(_ model: T) throws where T: PersistentModel, T: UniqueModel {
        let allModels = try modelContext.fetch(FetchDescriptor<T>())
        
        guard !allModels.contains(where: { $0.modelIdentifier == model.modelIdentifier }) else {
            return
        }
        
        modelContext.insert(model)
        try modelContext.save()
    }
    
    func read<T>(_ model: T.Type, withIdentifier identifier: String) throws -> T? where T: PersistentModel, T: UniqueModel {
        try readAll(T.self).first(where: { $0.modelIdentifier == identifier })
    }
    
    func readAll<T>(_ model: T.Type) throws -> [T] where T: PersistentModel, T: UniqueModel {
        try modelContext.fetch(FetchDescriptor<T>())
    }
    
    func delete<T>(_ modelType: T.Type, withIdentifier identifier: String) throws where T: PersistentModel, T: UniqueModel {
        guard let modelToDelete = try read(modelType, withIdentifier: identifier) else {
            return
        }
        
        modelContext.delete(modelToDelete)
        try modelContext.save()
    }
}
