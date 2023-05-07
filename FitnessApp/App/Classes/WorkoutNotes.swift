//
//  WorkoutNotes.swift
//  FitnessApp
//
//  Created by Archael dela Rosa on 5/4/23.
//

import Foundation

class WorkoutNotes: ObservableObject {
    private let entity: WorkoutNotesEntity
    
    @Published var id: UUID
    @Published var workoutID: UUID
    @Published var notes: String
    @Published var performanceRating: Int
    
    let NOTES_CHARACTER_LIMIT = 512
    let RATING_MAXIMUM = 10
    let RATING_MINIMUM = 0
    
    
    init(entity: WorkoutNotesEntity) {
        self.entity = entity
        self.id = entity.id!
        self.notes = entity.notes ?? ""
        self.performanceRating = Int(entity.performanceRating)
        self.workoutID = entity.workoutID!
    }
    
    func updateRating(_ rating: Int) -> Bool {
        if (rating > RATING_MAXIMUM || rating < RATING_MINIMUM) {
            print("Rating (\(rating)) is out of range \(RATING_MINIMUM)-\(RATING_MAXIMUM)")
            return false
        }
        entity.performanceRating = Int16(rating)
        self.performanceRating = rating
        return true
    }
    
    func updateNotes(_ notes: String) -> Bool {
        if (notes.count > NOTES_CHARACTER_LIMIT) {
            print("Notes Character Count (\(notes.count)) > \(NOTES_CHARACTER_LIMIT)")
            return false
        }
        entity.notes = notes
        self.notes = notes
        return true
    }
}
