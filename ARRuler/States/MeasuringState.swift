//
//  MeasuringState.swift
//  ARRulerMikavaa
//
//  Created by Johannes Heinke Business on 10.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

internal final class MeasuringState: State {
    
    private final lazy var bottomLabel: UILabel = {
        var label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 150, height: 50))
        _ = self.execute({ (viewcontroller) in
            label.center.x = viewcontroller.view.center.x
            label.center.y = viewcontroller.view.frame.height - (label.frame.height / 2)
        })
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.white
        label.alpha = 0.0
        label.textAlignment = .center
        label.backgroundColor = UIColor.darkGray
        return label
    }()
    
    private final func createSKView(width: CGFloat, height: CGFloat, _ viewcontroller: ViewController) -> SKView {
        var view = SKView.init()
        view = SKView.init(frame: CGRect.init(x: 0, y: 0
                , width: width
                , height: height))
        view.delegate = viewcontroller
        view.allowsTransparency = true
        view.backgroundColor = .clear
        return view
    }
    
    private final func executeForSpecificOrientation(horizontal: () -> Void, vertical: () -> Void, unknown: () -> Void) {
        switch UIDevice.current.orientation {
        case .faceDown, .faceUp, .portrait, .portraitUpsideDown:
            vertical()
        case .landscapeRight, .landscapeLeft:
            horizontal()
        case .unknown:
            unknown()
        }
    }
    
    //: SKView wird falsch initialisiert
    private final lazy var horizontalSKView: SKView = {
        var view = SKView.init()
        _ = self.execute({ (viewcontroller) in
            self.executeForSpecificOrientation(
            horizontal: {
                view = self.createSKView(width: viewcontroller.view.frame.width, height: viewcontroller.view.frame.height, viewcontroller)
            }, vertical: {
                view = self.createSKView(width: viewcontroller.view.frame.height, height: viewcontroller.view.frame.width, viewcontroller)
            }, unknown: {
                return
            })
        })
        return view
    }()
    
    private final lazy var verticalSKView: SKView = {
        var view = SKView.init()
        _ = self.execute({ (viewcontroller) in
            self.executeForSpecificOrientation(
            horizontal: {
                view = self.createSKView(width: viewcontroller.view.frame.height, height: viewcontroller.view.frame.width, viewcontroller)
            }, vertical: {
                view = self.createSKView(width: viewcontroller.view.frame.width, height: viewcontroller.view.frame.height, viewcontroller)
            }, unknown: {
                return
            })
        })
        return view
    }()
    
    private final lazy var displayScene: SKScene = {
        let scene = SKScene.init()
        scene.scaleMode = .aspectFill
        scene.backgroundColor = .clear
        let horizontalLine = SKSpriteNode.init(color: .black, size: CGSize.init(width: 0.2, height: 0.006))
        horizontalLine.position.x = scene.size.width / 2
        horizontalLine.position.y = scene.size.height / 2
        scene.addChild(horizontalLine)
        let verticalLine = SKSpriteNode.init(color: .black, size: CGSize.init(width: 0.006, height: 0.2))
        verticalLine.position.x = scene.size.width / 2
        verticalLine.position.y = scene.size.height / 2
        scene.addChild(verticalLine)
        
        return scene
    }()

    
    private final func resizeStandardLayout(for viewcontroller: ViewController) {
        self.bottomLabel.center.x = viewcontroller.view.center.x
        self.bottomLabel.center.y = viewcontroller.view.frame.height - (self.bottomLabel.frame.height / 2)
        
        self.executeForSpecificOrientation(
            horizontal: {
                self.horizontalSKView.alpha = 1.0
        }, vertical: {
                self.verticalSKView.alpha = 1.0
        }) {
            return
        }
    }
    
    private final func resizeWithoutAnimation(for viewcontroller: ViewController) {
        self.executeForSpecificOrientation(
            horizontal: {
                self.verticalSKView.alpha = 0.0
        }, vertical: {
            self.horizontalSKView.alpha = 0.0
        }) {
            return
        }
    }
    
    override internal final func setup() {
        _ = self.execute({ (viewcontroller) in
            viewcontroller.view.addSubview(self.horizontalSKView)
            self.horizontalSKView.presentScene(self.displayScene)
            viewcontroller.view.addSubview(self.verticalSKView)
            self.verticalSKView.presentScene(self.displayScene)
            viewcontroller.view.addSubview(self.bottomLabel)
            self.bottomLabel.text = "0.0cm / 0\""
            self.verticalSKView.alpha = 0.0
            self.horizontalSKView.alpha = 0.0
            UIView.animate(withDuration: 2, animations: {
                self.bottomLabel.alpha = 1.0
                self.resizeStandardLayout(for: viewcontroller)
            })
        })
    }
    
    override internal final func handleDidRotate() {
        _ = self.execute({ (viewcontroller) in
            UIView.animate(withDuration: 2, animations: {
                self.resizeStandardLayout(for: viewcontroller)
            })
        })
    }
    
    override internal final func handleWillRotate() {
        _ = self.execute({ (viewcontroller) in
            self.resizeWithoutAnimation(for: viewcontroller)
        })
    }
    
    override func handleTouchesBegan() {
        _ = self.execute({ (viewcontroller) in
            let results = viewcontroller.sceneView.worldPositionFromScreenPosition(viewcontroller.view.center, objectPos: nil)
            print(results)
        })
    }
}
