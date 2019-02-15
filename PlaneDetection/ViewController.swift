//
//  ViewController.swift
//  PlaneDetection
//
//  Created by Dilip Gurjar on 15/02/19.
//  Copyright © 2019 Dilip Gurjar. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.showsStatistics = true
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
      //  let torus = SCNTorus(ringRadius: 0.15, pipeRadius: 0.02)
        //        torus.firstMaterial?.diffuse.contents = UIColor.blue.withAlphaComponent(0.9)
        //        node.geometry = torus
        guard  let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        let extend = planeAnchor.extent
        
        let plane = SCNPlane(width: CGFloat(extend.x), height: CGFloat(extend.z))
            let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi/2
        planeNode.name = "arPlane"
     
        let anchoreNode = SCNScene(named: "art.scnassets/ship.scn")!.rootNode
        node.addChildNode(anchoreNode)
    }
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchore = anchor as? ARPlaneAnchor else {
            return}
        let extend = planeAnchore.extent
        let planeGeomatery = SCNPlane(width: CGFloat(extend.x), height: CGFloat(extend.z))
        planeGeomatery.firstMaterial?.diffuse.contents = UIColor.blue
        let planeNode = node.childNode(withName: "arPlane", recursively: false)
        
        planeNode?.geometry = planeGeomatery 
        
    }
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
