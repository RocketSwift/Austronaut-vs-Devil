//
//  GameViewController.swift
//  Austronaut vs Devil
//
//  Created by Denys Zahorskyi on 10.01.2023.
//


import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var scoreLabel : UILabel = {
        var scoreLabel = UILabel()
        scoreLabel.font = UIFont(name: "Chalkduster", size: 30)
        return scoreLabel
    }()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scoreLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            scoreLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
        ])
        
        if let view = self.view as! SKView?{
            let scene = GameScene(size: .zero)
            scene.scaleMode = .resizeFill
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    
}
