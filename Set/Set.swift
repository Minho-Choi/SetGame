//
//  Set.swift
//  Set
//
//  Created by Minho Choi on 2020/07/06.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import Foundation

struct Card: CustomStringConvertible {
    var description: String { return "\(shape) \(color) \(number) \(fill)"}
    
    
    var shape: Shape
    var color: Color
    var number: Number
    var fill: Fill
    
    var isFlipped = false
    var isSelected = false
    var identifier = 0
    
    enum Shape: String {
        case circle = "●"
        case star = "✶"
        case triangle = "▲"
        
        static var all = [Shape.circle, .star, .triangle]
    }
    
    enum Color: String {
        case black
        case orange
        case blue
        
        static var all = [Color.black, .orange, .blue]
    }
    
    enum Number: Int {
        case one = 1
        case two = 2
        case three = 3
        
        static var all = [Number.one, .two, .three]
    }
    
    enum Fill : String {
        case full
        case half
        case none
        
        static var all = [Fill.full, .half, .none]
    }
}
