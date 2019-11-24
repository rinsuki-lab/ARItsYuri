//
//  ViewController.swift
//  ARItsYuri
//
//  Created by user on 2019/11/24.
//  Copyright © 2019 rinsuki. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var previewNode: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        previewNode = getNewNode()
        previewNode.geometry!.firstMaterial!.transparency = 0.5
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

    let path = Bundle.main.path(forResource: "art.scnassets/ItsYuri", ofType: "png")!
    lazy var image = UIImage(contentsOfFile: path)
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let currentFrame = sceneView.session.currentFrame else { return }
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.1
        previewNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
    }

    func getNewNode() -> SCNNode {
        print(path)
        let plane = SCNPlane(width: 0.05, height: 0.05)
        plane.firstMaterial?.diffuse.contents = image
        plane.firstMaterial?.lightingModel = .constant
        let node = SCNNode(geometry: plane)
        sceneView.scene.rootNode.addChildNode(node)
        node.rotation = .init(0, 180, 0, 0)
        return node
    }
    
    @IBAction func handleTap() {
        guard let currentFrame = sceneView.session.currentFrame else { return }
        let node = getNewNode()
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.1
        node.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
        
    }
}
