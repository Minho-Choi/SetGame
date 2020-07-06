//
//  ViewController.swift
//  Set
//
//  Created by Minho Choi on 2020/07/06.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    var game = SetCardDeck()
    
    @IBAction func SetButton(_ sender: UIButton) {
        if let cardNumber = SetButtonArray.firstIndex(of: sender) {
            if cardNumber <
                game.shownCards.count {
                game.selectCard(at: cardNumber)
                updateView()
            } else {
                game.add3Cards()
                updateView()
            }
        } else {
            print("Not in cardButtons")
        }
    }
    
    @IBOutlet var SetButtonArray: [UIButton]!
    
    @IBOutlet weak var moreCardsButtonO: UIButton!
    @IBOutlet weak var newGameButtonO: UIButton!
    
    @IBAction func moreCardsButton(_ sender: UIButton) {
        game.add3Cards()
        updateView()
    }
    
    @IBAction func newGameButton(_ sender: UIButton) {
        game = SetCardDeck()
        updateView()
    }
    
    
    private func updateView() {
        for index in SetButtonArray.indices {
            let button = SetButtonArray[index]
            
            button.layer.cornerRadius = 10.0
            
            if index < game.shownCards.count {
                let card = game.shownCards[index]
                
                if card.isSelected {
                    button.layer.borderWidth = 4.0
                    button.layer.borderColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
                } else {
                    button.layer.borderWidth = 4.0
                    button.layer.borderColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
                    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
                
                var symbol = ""
                for _ in 0..<card.number.rawValue {
                    symbol += card.shape.rawValue
                }
                
                var fillDensity: CGFloat = 0.0
                var strokeThickness: NSNumber = 4.0
                if card.fill.rawValue == "half" {
                    fillDensity = 0.15
                    strokeThickness = -1.0
                } else if card.fill.rawValue == "full" {
                    fillDensity = 1.0
                    strokeThickness = -1.0
                }
                
                let attributedString = NSMutableAttributedString(string: symbol)
                
                if card.color.rawValue == "orange" {
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange.withAlphaComponent(fillDensity), range: NSRange(location: 0, length: attributedString.string.count))
                    attributedString.addAttribute(NSAttributedString.Key.strokeWidth, value: strokeThickness, range: NSRange(location: 0, length: attributedString.string.count))
                    attributedString.addAttribute(NSAttributedString.Key.strokeColor, value: UIColor.orange, range: NSRange(location: 0, length: attributedString.string.count))
                } else if card.color.rawValue == "blue" {
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue.withAlphaComponent(fillDensity), range: NSRange(location: 0, length: attributedString.string.count))
                    attributedString.addAttribute(NSAttributedString.Key.strokeWidth, value: strokeThickness, range: NSRange(location: 0, length: attributedString.string.count))
                    attributedString.addAttribute(NSAttributedString.Key.strokeColor, value: UIColor.blue, range: NSRange(location: 0, length: attributedString.string.count))
                } else {
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black.withAlphaComponent(fillDensity), range: NSRange(location: 0, length: attributedString.string.count))
                    attributedString.addAttribute(NSAttributedString.Key.strokeWidth, value: strokeThickness, range: NSRange(location: 0, length: attributedString.string.count))
                    attributedString.addAttribute(NSAttributedString.Key.strokeColor, value: UIColor.black, range: NSRange(location: 0, length: attributedString.string.count))
                }
                button.setAttributedTitle(attributedString, for: UIControl.State.normal)
                
                if !card.isFlipped {
                    let attributedString = NSMutableAttributedString(string: "")
                    button.setAttributedTitle(attributedString, for: UIControl.State.normal)
                    button.layer.borderWidth = -1.0
                    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
                
                
            } else {
                let attributedString = NSMutableAttributedString(string: "☻")
                button.setAttributedTitle(attributedString, for: UIControl.State.normal)
                button.layer.borderWidth = -1.0
                button.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            }
        }
        if game.deckEmpty {
            moreCardsButtonO.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
            moreCardsButtonO.setTitle("Deck is Empty!", for: UIControl.State.normal)
        }
    }
}

