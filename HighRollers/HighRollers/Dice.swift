//
//  Dice.swift
//  HighRollers
//
//  Created by Deepankar Das on 16/12/25.
//

import Foundation
import SwiftData


@Model
class Dice {
    var sides : Int
    var lastRoll: Int?
    
    init(sides: Int) {
        self.sides = sides
    }
}
