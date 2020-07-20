//
//  CardContainer.swift
//  Graphical Set
//
//  Created by Minho Choi on 2020/07/18.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import UIKit

class CardContainer: UIView {

    var buttons = [SetShapeView]()
    
    lazy var grid = Grid(layout: Grid.Layout.aspectRatio(0.7))

    var centeredRect: CGRect {
        return CGRect(x: bounds.size.width * 0.025, y: bounds.size.height * 0.025, width: bounds.size.width * 0.95, height: bounds.size.height * 0.95)
    }
    
    func offsetRect(of frame: CGRect) -> CGRect {
        return CGRect(x: frame.size.width * 0.025 + frame.minX, y: frame.size.height * 0.025 + frame.minY, width: frame.size.width * 0.95, height: frame.size.height * 0.95)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        grid.frame = centeredRect
        
        for (i, button) in buttons.enumerated() { // return tuple(i, button)
            if let frame = grid[i] {
                button.frame = offsetRect(of: frame)
                button.isOpaque = false
                button.layer.cornerRadius = button.frame.width * 0.1
                button.layer.borderWidth = button.frame.width * 0.05
                button.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
        }
    }
    
    func updateButtons(of deck: [Card]) { // 이 부분이 핵심
        let cardButtons = (0..<deck.count).map { _ in SetShapeView() }
        
        for (i, button) in cardButtons.enumerated() {
            button.color = deck[i].color.rawValue
            button.fill = deck[i].fill.rawValue
            button.shape = deck[i].shape.rawValue
            button.number = deck[i].number.rawValue
            if deck[i].isSelected {
                button.layer.borderColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
            } else if deck[i].isHint {
                button.layer.borderColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            } else {
                button.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
            addSubview(button)
        }
        buttons = cardButtons
        grid.cellCount = buttons.count
        setNeedsLayout()
        setNeedsDisplay()
    }

    func clearCardContainer() {
        buttons = []
        grid.cellCount = 0
        removeAllSubviews()
        setNeedsLayout()
    }
    

}

extension UIView {
    func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}
