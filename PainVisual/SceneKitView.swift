//
//  SceneKitView.swift
//  PainVisual
//
//  Created by Raymundo Mondragon Lara on 25/03/24.
//

import SwiftUI
import SceneKit

struct SceneKitView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        
        // Create a new Scene
        let scene = SCNScene(named: "body.dae") // Make sure to use the correct file name
        
        // Create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        // Place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        
        scene?.rootNode.addChildNode(cameraNode)
        
        // Create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene?.rootNode.addChildNode(lightNode)
        
        // Create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor(white: 0.67, alpha: 1.0) // Soft white light
        scene?.rootNode.addChildNode(ambientLightNode)
        
        let positions = [
            SCNVector3(x: 10, y: 10, z: 10),
            SCNVector3(x: -10, y: 10, z: 10),
            SCNVector3(x: 10, y: -10, z: 10),
            SCNVector3(x: -10, y: -10, z: 10)
        ]
        
        // Create and add a directional light to the scene
        for position in positions {
            let lightNode = SCNNode()
            lightNode.light = SCNLight()
            lightNode.light?.type = .omni
            lightNode.light?.color = UIColor(white: 0.75, alpha: 1.0) // Soft white light
            lightNode.position = position
            scene?.rootNode.addChildNode(lightNode)
        }
        // Set the scene to the view
        scnView.scene = scene
        
        // Allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // Show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // Configure the view
        scnView.backgroundColor = UIColor.black
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
        
        return scnView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        // Update the view if needed
    }
}


extension SceneKitView {
    class Coordinator: NSObject {
        var parent: SceneKitView

        init(_ parent: SceneKitView) {
            self.parent = parent
        }

        @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
            guard let scnView = gestureRecognize.view as? SCNView else {
                return
            }

            // Check what nodes are tapped
            let p = gestureRecognize.location(in: scnView)
            let hitResults = scnView.hitTest(p, options: [:])
            // Check that we clicked on at least one object
            if hitResults.count > 0 {
                // Retrieved the first clicked object
                let result = hitResults[0]
                
                // Get the node and its material
                let node = result.node
                
                // Change the material's color to indicate selection
                // Remember the original color to reset it later
                let originalColor = node.geometry?.firstMaterial?.diffuse.contents
                node.geometry?.firstMaterial?.diffuse.contents = UIColor.green // Change to your highlight color
                
                // Optional: Reset color after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Adjust time as needed
                    node.geometry?.firstMaterial?.diffuse.contents = originalColor
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
