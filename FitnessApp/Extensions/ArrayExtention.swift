//
//  ArrayExtention.swift
//  FitnessApp
//
//  Created by Archael dela Rosa on 5/7/23.
//

import Foundation

extension Array {
    
    mutating func rearrange(fromIndex: Int, toIndex: Int) -> Bool {
        // Check Bounds
        guard fromIndex != toIndex, indices.contains(fromIndex), indices.contains(toIndex) else {
            return false
        }
        let element = remove(at: fromIndex)
        insert(element, at: toIndex)
        return true
    }
}
