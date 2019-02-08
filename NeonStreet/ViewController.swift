//
//  ViewController.swift
//  NeonStreet
//
//  Created by joseewu on 2019/2/8.
//  Copyright © 2019 com.js.neon. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import ARCL
import CoreLocation
class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    var sceneLocationView = SceneLocationView()
    var currentAltitude:CLLocationDistance = 0
    var currentLocation:CLLocationCoordinate2D?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneLocationView.locationDelegate = self
        sceneView.showsStatistics = false
        sceneView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        // Create a new scene
        let scene:SCNScene = SCNScene()
        sceneView.scene = scene
        sceneLocationView.run()
        view.addSubview(sceneLocationView)

        let plane = SCNPlane(width: 0.4,
                             height: 0.4)
        //標tag
        let planeNode = SCNNode(geometry: plane)

        planeNode.localTranslate(by: SCNVector3(0, 0, -0.5))
        planeNode.opacity = 1
        if let current = sceneLocationView.currentLocation() {
            let mosquitoLocationNode = LocationSceneNode(location: current, node: planeNode)

            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: mosquitoLocationNode)
            sceneView.scene.rootNode.addChildNode(mosquitoLocationNode)
        }

    }
    private func addLocationNote(at location:CLLocation, with rootNode:SCNNode?) {
        guard let rootNode = rootNode else {
            return
        }
        let plane = SCNPlane(width: 0.4,
                             height: 0.4)
        //標tag
        let planeNode = SCNNode(geometry: plane)

        planeNode.localTranslate(by: SCNVector3(0, 0, -0.5))
        planeNode.opacity = 1
        rootNode.addChildNode(planeNode)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create a session configuration
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
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
}
extension ViewController:SceneLocationViewDelegate {
    func sceneLocationViewDidAddSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        currentLocation = location.coordinate
        currentAltitude = location.altitude
    }

    func sceneLocationViewDidRemoveSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {

    }

    func sceneLocationViewDidConfirmLocationOfNode(sceneLocationView: SceneLocationView, node: LocationNode) {
    }

    func sceneLocationViewDidSetupSceneNode(sceneLocationView: SceneLocationView, sceneNode: SCNNode) {

    }

    func sceneLocationViewDidUpdateLocationAndScaleOfLocationNode(sceneLocationView: SceneLocationView, locationNode: LocationNode) {

    }


}
