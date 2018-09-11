//
//  ViewController.swift
//  ARRulerMikavaa
//
//  Created by Johannes Heinke Business on 10.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

internal final class ViewController: UIViewController, ARSCNViewDelegate, SKViewDelegate, isStateHandler {

    @IBOutlet var sceneView: ARSCNView!
    
    private final var _currentState: State = StartState.init()
    
    internal final var currentState: State {
        get {
            return self._currentState
        }
        
        set(newState) {
            self._currentState.removeLayout()
            self._currentState = newState
            self._currentState.setup()
        }
    }
    
    internal final let startState: StartState = StartState.init()
    internal final let measureState: MeasuringState = MeasuringState.init()
    internal final let walkingState: WalkingState = WalkingState.init()
    
    private final func setupStatePattern() {
        _ = self.startState.add(content: self)
        _ = self.measureState.add(content: self)
        _ = self.walkingState.add(content: self)
        self._currentState = self.startState
        self._currentState.setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        // Create a new scene
        let scene = SCNScene.init()
        // Set the scene to the view
        sceneView.scene = scene
        self.setupStatePattern()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self._currentState.handleDidRotate()
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self._currentState.handleWillRotate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self._currentState.handleTouchesBegan()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        self._currentState.handleUpdate()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
