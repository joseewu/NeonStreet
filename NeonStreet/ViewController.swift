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
import Metal
class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    var sceneLocationView = SceneLocationView()
    var currentAltitude:CLLocationDistance = 0
    var currentLocation:CLLocationCoordinate2D? {
        didSet {
            if oldValue == nil {

                let location = CLLocation(latitude: currentLocation?.latitude ?? 0, longitude: currentLocation?.longitude ?? 0)
                let externalNode = SCNScene(named: "art.scnassets/sign_neon_small.scn")!.rootNode.clone()
                //                addGlowTechnique(node: externalNode, sceneView: sceneView)
                let node = LocationSceneNode(location: location, node: externalNode)
                let audioPlayer = SCNAudioPlayer(source: audioSource)
                externalNode.addAudioPlayer(audioPlayer)
                audioSource.volume = 0.5
                let play = SCNAction.playAudio(audioSource, waitForCompletion: true)
                externalNode.runAction(play)

                if let particelSystem = SCNParticleSystem(named: "rain.scnp", inDirectory: nil) {
                    particelSystem.emissionDuration = 0.5
                    particelSystem.particleColor = UIColor.red
                    particelSystem.particleIntensity = 500
                    sceneView.scene.rootNode.addParticleSystem(particelSystem)
                }
//                sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: node)
//                sceneView.scene.rootNode.addChildNode(externalNode)
            }
        }
    }
    var audioSource:SCNAudioSource!
    func creatNeonLight(atLocation location:CLLocation) -> ( LocationSceneNode,SCNNode)  {
        let externalNode = SCNScene(named: "art.scnassets/ship.scn")!.rootNode.clone()
        let node = LocationSceneNode(location: location, node: externalNode)
        return (node, externalNode)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        audioSource = SCNAudioSource(fileNamed: "ARMono.mp3")
        audioSource.loops = true
        audioSource.load()
        // Set the view's delegate
        sceneView.delegate = self

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneLocationView.locationDelegate = self
        sceneView.showsStatistics = false
        // Create a new scene
        let scene:SCNScene = SCNScene()
        sceneView.scene = scene
        sceneLocationView.run()

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
extension ViewController {
    public func addGlowTechnique(node:SCNNode ,sceneView:ARSCNView){
        node.setHighlighted()
        guard let path = Bundle.main.path(forResource: "NodeTechnique", ofType: "plist") else {return}
        guard let dict = NSDictionary(contentsOfFile: path) as? [String:Any] else {return}
        let technique = SCNTechnique(dictionary:dict)
        sceneView.technique = technique
    }
}
extension SCNNode {
    func setHighlighted( _ highlighted : Bool = true, _ highlightedBitMask : Int = 2 ) {
        categoryBitMask = highlightedBitMask
        for child in self.childNodes {
            child.setHighlighted()
        }
    }
}

extension ViewController:ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        //get location
        //        let width = CGFloat(planeAnchor.extent.x)
        //        let height = CGFloat(planeAnchor.extent.z)
        //        let plane = SCNPlane(width: width, height: height)
        //        plane.materials.first?.diffuse.contents = UIColor.yellow.withAlphaComponent(0.5)
        //        let planeNode = SCNNode(geometry: plane)
        //        let x = CGFloat(planeAnchor.center.x)
        //        let y = CGFloat(planeAnchor.center.y)
        //        let z = CGFloat(planeAnchor.center.z)
        //        planeNode.position = SCNVector3(x,y,z)
        //        planeNode.eulerAngles.x = -.pi / 2
        //        node.addChildNode(planeNode)
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
