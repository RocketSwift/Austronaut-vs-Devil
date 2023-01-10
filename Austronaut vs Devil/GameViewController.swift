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
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
