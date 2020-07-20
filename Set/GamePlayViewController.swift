//
//  ViewController.swift
//  Set
//
//  Created by Minho Choi on 2020/07/06.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import UIKit

class GamePlayViewController: UIViewController {
    
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var cardsContainerView: CardContainer! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(addCard))
            swipe.direction = [.down]
            cardsContainerView.addGestureRecognizer(swipe)
            let tweak = UIRotationGestureRecognizer(target: self, action: #selector(shuffleCard))
            tweak.rotation = 0
            cardsContainerView.addGestureRecognizer(tweak)
            updateButton()
        }
    }
    
    
    @IBAction func hintButton(_ sender: UIButton) {
        game.hintSet(pip: false)
        updateButton()
    }
    
    @IBOutlet weak var hintButtonLook: UIButton!
    

    
    @IBAction func newGame(_ sender: UIButton) {
        game = SetCardDeck()
        updateButton()
    }
    
    lazy var game = SetCardDeck()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardsContainerView.layer.backgroundColor = #colorLiteral(red: 0.6308920066, green: 0.1232711207, blue: 0.2445295539, alpha: 1)
        cardsContainerView.updateButtons(of: game.shownCards)
        assignTargetAction()
    }
    
    private func assignTargetAction() {
      for button in cardsContainerView.buttons {
        button.addTarget(self, action: #selector(didTapCard(_:)), for: .touchUpInside)
      }
    }
    
    @objc func didTapCard(_ sender: UIButton) {
        let index = cardsContainerView.buttons.firstIndex(of: sender as! SetShapeView)!
        game.selectCard(at: index)
        print("tap \(index)")
        updateButton()
    }
    
    @objc func addCard() {
        game.add3Cards()
        print("add 3 cards")
        print(game.shownCards.count)
        updateButton()
    }
    
    @objc func shuffleCard() {
        game.shuffleDeck()
        print("shuffle cards")
        updateButton()
    }
    
    private func updateButton() {
        if game.gameOver {
            print("game over")
            gameOverAnimation()
        }
        cardsContainerView.clearCardContainer()
        cardsContainerView.updateButtons(of: game.shownCards)
        assignTargetAction()
        if let scoreboard = scoreLabel {
            scoreboard.text = "Score: \(game.score)"
        }
    }
    
    func gameOverAnimation() {
        
    }
}

