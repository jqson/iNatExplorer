//
//  SwiftDataService.swift
//  iNatExplorer
//
//  Created by Yuanfeng Jiao on 6/4/25.
//

import Foundation
import SwiftData

class SwiftDataService {
    
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @MainActor
    static let shared = SwiftDataService()
    
    @MainActor
    private init() {
        self.modelContainer = try! ModelContainer(for: SavedSpecies.self, configurations: ModelConfiguration())
        self.modelContext = modelContainer.mainContext
    }
    
    func fetchSavedSpecies() -> [SavedSpecies] {
        do {
            return try modelContext.fetch(FetchDescriptor<SavedSpecies>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func addSavedSpecies(_ savedSpecies: SavedSpecies) {
        modelContext.insert(savedSpecies)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
