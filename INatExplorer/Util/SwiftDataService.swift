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
        self.modelContainer = try! ModelContainer(for: SavedSpecies.self, configurations: .init())
        self.modelContext = modelContainer.mainContext
        self.modelContext.autosaveEnabled = false
    }
    
    func fetchSavedSpecies() -> [SavedSpecies] {
        do {
            return try modelContext.fetch(FetchDescriptor<SavedSpecies>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func addSavedSpecies(_ savedSpecies: [SavedSpecies]) {
        guard !savedSpecies.isEmpty else { return }
        
        for item in savedSpecies {
            modelContext.insert(item)
        }
        
        do {
            try modelContext.save()
            print("Saved \(savedSpecies.count) species")
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func removeSavedSpecies(_ savedSpecies: [SavedSpecies]) {
        guard !savedSpecies.isEmpty else { return }
        
        for item in savedSpecies {
            modelContext.delete(item)
        }
        
        do {
            try modelContext.save()
            print("Deleted \(savedSpecies.count) species")
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
