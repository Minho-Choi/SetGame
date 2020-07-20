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
    var shownCards = [Card]() {
        didSet {
            if shownCards.count == 0 {
                gameOver = true
            }
        }
    }
    var selectedCards = [Card]()
    var answerIndexDeck = [[Int]]()
    var randomAnswer = [Int]()
    
    var deckEmpty = false
    var noSpace = false
    var smlieySmiles = true
    var gameOver = false
    var setLabel = 0
    var score = 0
    let startTime = Date()
    var setTime = Date()
    
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
    
    mutating func draw() -> Card? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.arc4random)
        } else {
            return nil
        }
    }
    
    mutating func add3Cards() {
        setLabel = 3 // add card
        if !deckEmpty {
            for _ in 0 ..< 3 {
                if var card = draw() {
                    card.isFlipped = true
                    shownCards.append(card)
                    if shownCards.count == 24 {
                        noSpace = true
                    }
                    if cards.count == 0 {
                        deckEmpty = true
                    }
                    score += -2
                    smlieySmiles = false
                } else {
                    print("No more cards")
                    deckEmpty = true
                }
            }
        } else {
            gameOver = true
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
                    if isSet(for: selectedCards) {
                        print("Set!")
                        for index in selectedCards.indices {
                            if var newCard = draw() {
                                newCard.isFlipped = true
                                shownCards[selectedCards[index].identifier] = newCard
                            } else {
                                shownCards = shownCards.filter{$0.description != selectedCards[index].description}
                                deckEmpty = true
                            }
                            answerIndexDeck = []
                        }
                        hintSet(pip: true)
                        if randomAnswer == [] {
                            add3Cards()
                        }
                        setLabel = 1 // set
                        score += 5
                        smlieySmiles = true
                    } else {
                        for index in selectedCards.indices {
                            shownCards[selectedCards[index].identifier].isSelected = false
                        }
                        setLabel = 2 // not set
                        score += -3
                        smlieySmiles = false
                    }
                    selectedCards = []
                }
            } else if shownCards[index].isSelected {
                let doubleClicked = shownCards[index]
                for smallIndex in selectedCards.indices {
                    if doubleClicked.description == selectedCards[smallIndex].description {
                        selectedCards.remove(at: smallIndex)
                        break
                    }
                }
                shownCards[index].isSelected = false
            }
        }
    }

    private func isSet(for deck: [Card]) -> Bool {
        let testArray = [String](repeating: "", count: 4)
        var testArray2 = [[String]](repeating: testArray, count: 3)
        var countArray = [Int](repeating: 0, count: 4)
        
        for faceIndex in 0..<4 {
            for setIndex in 0..<3 {
                let interestedProperty = deck[setIndex].description[faceIndex]
                testArray2[setIndex][faceIndex] = interestedProperty
            }
        }
        testArray2.append(testArray2[0])
        for faceIndex in 0..<4 {
            for setIndex in 0..<3 {
                if testArray2[setIndex][faceIndex] == testArray2[setIndex + 1][faceIndex] {
                    countArray[faceIndex] += 1  // 모두 같을 시 3, 모두 다를 시 0, 그 외 1
                }
            }
            if countArray[faceIndex] == 1 {
                return false
            }
        }
        return true
    }
    
    mutating func hintSet(pip isTrueHint: Bool) {
        answerIndexDeck = []
        for index1 in 0..<shownCards.count - 2 {
            for index2 in index1 + 1..<shownCards.count - 1 {
                for index3 in index2 + 1..<shownCards.count {
                    if shownCards[index1].isFlipped, shownCards[index2].isFlipped, shownCards[index3].isFlipped {
                        let testDeck = [shownCards[index1], shownCards[index2], shownCards[index3]]
                        let testDeckIndex = [index1, index2, index3]
                        if isSet(for: testDeck) {
                            answerIndexDeck.append(testDeckIndex)
                        }
                        if answerIndexDeck.count == 3 { break }
                    }
                };if answerIndexDeck.count == 3 { break }
            };if answerIndexDeck.count == 3 { break }
        }
        
        for index in shownCards.indices {
            shownCards[index].isHint = false
        }
        if !isTrueHint {
            if answerIndexDeck != [] {
                randomAnswer = answerIndexDeck[answerIndexDeck.count.arc4random]
                for index in 0...2 {
                    shownCards[randomAnswer[index]].isHint = true
                }
            } else {
                if cards.count == 0 {
                    gameOver = true
                } else {
                    add3Cards()
                    score += 6
                    setLabel = 4
                }
            }
        }
        print(answerIndexDeck)
    }
    
    mutating func shuffleDeck() {
        shownCards.shuffle()
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
