//
//  WorkoutRep.swift
//  FitnessApp
//
//  Created by Archael dela Rosa on 5/4/23.
//

import Foundation

class WorkoutRep: ObservableObject {
    private let entity: RepEntity
    
    @Published var id: UUID
    @Published var weight: Double
    @Published var reps: Int
    @Published var isCompleted: Bool
    @Published var index: Int
    @Published var setID: UUID
    
    
    
    init(entity: RepEntity) {
        self.entity = entity
        self.id = entity.id!
        self.reps = Int(entity.reps)
        self.weight = entity.weight
        self.isCompleted = entity.isCompleted
        self.index = Int(entity.index)
        self.setID = entity.setID!
    }
    
    func update(weight: Double, reps: Int) {
        self.weight = weight
        entity.weight = weight
        self.reps = reps
        entity.reps = Int16(reps)
    }
    
    func delete() {
        CoreDataManager.shared.deleteEntity(entity: self.entity) // Delete Entity
    }
    
    func toggleCompleted() {
        isCompleted = !isCompleted
        self.entity.isCompleted = isCompleted
    }
}
