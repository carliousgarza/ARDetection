//
//  ViewController.swift
//  videoCredencial
//
//  Created by Alumno on 10/29/19.
//  Copyright © 2019 itesm. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController, ARSCNViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Asignamos el propio delegado
        sceneView.delegate = self
        // Herramienta para mostrR FPS y tiempo
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARImageTrackingConfiguration()
        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "Credencial", bundle: Bundle.main){
            configuration.trackingImages = trackedImages
            configuration.maximumNumberOfTrackedImages = 1
        }
        sceneView.session.run(configuration)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        if let imageAnchor = anchor as? ARImageAnchor{
            let path = Bundle.main.path(forResource: "IMG_3973", ofType: "mov")
            let videoUrl = URL(fileURLWithPath: path!)
            player = AVPlayer(url: videoUrl)
            videoNode = SKVideoNode(avPlayer: player)
            videoScene = SKScene(size: CGSize(width: 1280, height: 720))
            videoNode.position = CGPoint(x: videoScene.size.width/2, y: videoScene.size.height/2)
            videoNode.yScale = -1.0
            videoScene.addChild(videoNode)
            let widthPlane = imageAnchor.referenceImage.physicalSize.width
            let heightPlane = imageAnchor.referenceImage.physicalSize.height
            plane = SCNPlane(width: widthPlane, height: heightPlane)
            plane.firstMaterial?.diffuse.contents = videoScene
            planeNode = SCNNode(geometry : plane)
            planeNode.eulerAngles.x = -.pi/2
            node.addChildNode(planeNode)
            player.play()
        }
        return node
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    var videoScene = SKScene()
    var player = AVPlayer()
    var node = SCNNode()
    var plane = SCNPlane()
    var planeNode = SCNNode()
    var videoNode = SKVideoNode(fileNamed: "IMG_3973.mov")
    
    
    
    @IBAction func restart(_ sender: UIButton) {
        player.seek(to: CMTime(seconds: 0, preferredTimescale: 100))
        player.play()
    }
    @IBAction func pause(_ sender: UIButton) {
        player.pause()
    }
    @IBAction func play(_ sender: UIButton) {
        player.play()
    }
}
