//
//  GameViewController.swift
//  game
//
//  Created by Martin Jaroszewicz on 7/13/15.
//  Copyright (c) 2015 com.jaroszewicz. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion

class information: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    func getTilt() -> Int{
        
        return UIDevice.currentDevice().orientation.rawValue
    }
}
