//
//  CarModel.swift
//  Cool Cars
//
//  Created by Eddie Char on 2/11/22.
//

import UIKit

struct CarModel: Equatable, Codable {
    enum Direction: Codable {
        case left, right
    }
    
    let make: String
    let model: String
    let year: Int
    let mpgCity: Double
    let mpgHighway: Double
    let hp: Int
    let zeroToSixty: Double
    let imageName: String
    let imageFacing: Direction
    var milesThisMonth: Int = 0 {
        didSet {
            if milesThisMonth > maxMiles {
                milesThisMonth = maxMiles
            }
        }
    }
    var maxMiles = 2000
    
    
    static func ==(lhs: CarModel, rhs: CarModel) -> Bool {
        return lhs.make == rhs.make && lhs.model == rhs.model && lhs.year == rhs.year
    }
}
