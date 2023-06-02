//
//  ContentView.swift
//  SceneKitTest
//
//  Created by hyebin on 2023/05/30.
//

import SwiftUI
import SceneKit

struct ContentView: View {
    var body: some View {
        SceneViewWrapper()
            .edgesIgnoringSafeArea(.all)
    }
}

struct SceneViewWrapper: UIViewRepresentable {
    typealias UIViewType = SCNView
    let sceneView = SCNView()
    
    func makeUIView(context: Context) -> SCNView {
        sceneView.backgroundColor = .white
        sceneView.scene = createChessScene()
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
            
        let tapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
            sceneView.addGestureRecognizer(tapGestureRecognizer)
            
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        // Update your view, if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        let parent: SceneViewWrapper
        
        init(_ parent: SceneViewWrapper) {
            self.parent = parent
        }
        
        @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
            let location = gestureRecognizer.location(in: gestureRecognizer.view)
            let hitTestResults = parent.sceneView.hitTest(location, options: nil)
            
            if let hitNode = hitTestResults.first?.node {
                // SCNNode를 터치했을 때 수행할 작업을 여기에 추가하세요.
                print("Touched SCNNode: \(hitNode.geometry?.name)")
            }
        }
    }
    
    func createChessScene() -> SCNScene {
        let scene = SCNScene()
        
        let chessboardNode = SCNNode()
        for row in 0..<8 {
            for column in 0..<8 {
                let box = SCNBox(width: 1.0, height: 0.1, length: 1.0, chamferRadius: 0)
                let boxNode = SCNNode(geometry: box)
                boxNode.position = SCNVector3(Float(column), 0, Float(row))
                
                if (row + column) % 2 == 0 {
                    boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
                } else {
                    boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor.darkGray
                }
                
                chessboardNode.addChildNode(boxNode)
            }
        }
        
        let node = loadDAEFile(named: "Tree_Spruce_tiny_01")!
        node.position = SCNVector3(3.0, 0.1, 3.0)
        chessboardNode.addChildNode(node)
        
        scene.rootNode.addChildNode(chessboardNode)
        
        return scene
    }
    
    func loadDAEFile(named fileName: String) -> SCNNode? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "dae") else {
            print("Failed to find \(fileName).dae in the main bundle.")
            return nil
        }

        let sceneSource = SCNSceneSource(url: url, options: nil)
        let sceneOptions = [SCNSceneSource.LoadingOption.convertToYUp: true]
        
        do {
            guard let scene = try sceneSource?.scene(options: sceneOptions) else {
                print("Failed to create SCNScene from \(fileName).dae.")
                return nil
            }
            
            guard let node = scene.rootNode.childNode(withName: fileName, recursively: true) else {
                print("No node named \(fileName) found in \(fileName).dae.")
                return nil
            }
            let rotation = SCNVector4(x: 2, y: 0, z: 0, w: Float.pi / -2)
            node.rotation = rotation
            node.scale = SCNVector3(x: 0.2, y: 0.2, z: 0.2)

            return node
        } catch {
            print("Error loading \(fileName).dae: \(error.localizedDescription)")
            return nil
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
