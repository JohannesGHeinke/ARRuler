//
//  State.swift
//  ARRulerMikavaa
//
//  Created by Johannes Heinke Business on 10.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation
import UIKit

protocol isStateHandler {
    var currentState: State { get set }
}

internal class State {
    
    private final var content: ViewController?
    
    init(with content: ViewController? = nil) {
        self.content = content
    }
    
    internal final func add(content: ViewController) -> Bool {
        guard self.content != nil else {
            self.content = content
            return true
        }
        return false
    }
    
    internal final func execute(_ closure: (_ content: ViewController) -> Void) -> Bool {
        guard let safeContent = self.content else {
            return false
        }
        closure(safeContent)
        return true
    }
    
    internal func setup() {}
    internal func removeLayout() {}
    internal func handleTouchesBegan() {}
    internal func handleDidRotate() {}
    internal func handleWillRotate() {}
    internal func handleUpdate() {}
}
