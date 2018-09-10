//
//  StartState.swift
//  ARRulerMikavaa
//
//  Created by Johannes Heinke Business on 10.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation
import UIKit

internal final class StartState: State {
    
    private final func resizeStandardLayout(for viewcontroller: ViewController) {
        self.headLabel.center.x = viewcontroller.view.center.x
    }
    
    private final lazy var headLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 50))
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    
    private var repeatPulse: Bool = true
    private func pulseHeadLabel() {
        UIView.animate(withDuration: 1, animations: {
            self.headLabel.alpha = 0.2
        }) { (_) in
            UIView.animate(withDuration: 1, animations: {
                self.headLabel.alpha = 1.0
            }, completion: { (_) in
                if self.repeatPulse {
                    self.pulseHeadLabel()
                }
            })
        }
    }
    
    override internal final func setup() {
        guard self.execute({ (viewcontroller) in
            viewcontroller.view.addSubview(self.headLabel)
            self.headLabel.text = "Tap to start!"
            self.resizeStandardLayout(for: viewcontroller)
            self.pulseHeadLabel()
        }) else {
            //: Executed if no content exists
            return
        }
    }
    
    override final func removeLayout() {
        _ = self.execute({ (viewcontroller) in
            self.repeatPulse = false
            UIView.animate(withDuration: 1, animations: {
                self.headLabel.alpha = 0.0
            }, completion: { (_) in
                self.headLabel.removeFromSuperview()
            })
        })
    }
    
    override final func handleTouchesBegan() {
        _ = self.execute({ (viewcontroller) in
            viewcontroller.currentState = viewcontroller.measureState
        })
    }
    
    override final func handleDidRotate() {
        _ = self.execute({ (viewcontroller) in
            UIView.animate(withDuration: 2, animations: {
                self.resizeStandardLayout(for: viewcontroller)
            })
        })
    }
}
