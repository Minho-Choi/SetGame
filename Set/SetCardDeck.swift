//
//  SetCardDeck.swift
//  Set
//
//  Created by Minho Choi on 2020/07/06.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import Foundation

struct SetCardDeck { //81 cards
    
    private(set) var cards = [Card]()
    var shownCards = [Card]()
    var selectedCards = [Card]()
    
    var deckEmpty = false
    var noSpace = false
    
    init() {
        for shape in Card.Shape.all {
            for color in Card.Color.all {
                for number in Card.Number.all {
                    for fill in Card.Fill.all {
                        cards.append(Card(shape: shape, color: color, number: number, fill: fill))
                    }
                }
            }
        }
        for index in 0 ..< 12 {  // 카드 12장 추가
            if let card = draw() {
                shownCards.append(card)
                shownCards[index].isFlipped = true
            }
        }
    }
    
    private mutating func draw() -> Card? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.arc4random)
        } else {
            return nil
        }
    }
    
    mutating func add3Cards() {
        if shownCards.count < 24 {
            for _ in 0 ..< 3 {
                if var card = draw() {
                    card.isFlipped = true
                    shownCards.append(card)
                }
                else {
                    print("No more cards")
                    deckEmpty = true
                }
            }
        } else {
            print("Screen is full")
            noSpace = true
        }
    }
    
    mutating func selectCard(at index: Int) {
        if shownCards[index].isFlipped {
            if !shownCards[index].isSelected, selectedCards.count < 4 {
                var selection = shownCards[index]
                shownCards[index].isSelected = true
                selection.identifier = index
                selectedCards.append(selection)
                print(selection.description)
                if selectedCards.count == 3 {
                    if isSet() {
                        for index in selectedCards.indices {
                            if var newCard = draw() {
                                newCard.isFlipped = true
                                shownCards[selectedCards[index].identifier] = newCard
                            } else {
                                shownCards[ selectedCards[index].identifier].isFlipped = false
                                deckEmpty = true
                            }
                        }
                        print("you've made a set")
                    } else {
                        for index in selectedCards.indices {
                            shownCards[selectedCards[index].identifier].isSelected = false
                        }
                        print("wrong set")
                    }
                    selectedCards = []
                }
            } else if shownCards[index].isSelected {
                let doubleClicked = shownCards[index]
                for smallIndex in selectedCards.indices {
                    if doubleClicked.description == selectedCards[smallIndex].description {
                        selectedCards.remove(at: smallIndex)
                    }
                }
                shownCards[index].isSelected = false
            }
        }
    }
// TODO : Remake Set Algorithm
    private func isSet() -> Bool {
        if selectedCards[0].color == selectedCards[1].color {
            if selectedCards[0].color == selectedCards[2].color {
                return true
            } else { return false }
        } else if selectedCards[0].shape == selectedCards[1].shape {   if selectedCards[0].shape == selectedCards[2].shape {
                return true
            } else { return false }
        } else if selectedCards[0].fill == selectedCards[1].fill {
            if selectedCards[0].fill == selectedCards[2].fill {
                return true
            } else { return false }
        } else if selectedCards[0].number == selectedCards[1].number {  if selectedCards[0].number == selectedCards[2].number {
                return true
            } else { return false }
        } else { return true }
    }
}


extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
}
