//
//  Rotation.swift
//  RotationTutorial
//
//  Created by Nayeon Kim on 2023/05/30.
//

import SwiftUI
import SceneKit
//import ModelIO
//import SceneKit.ModelIO

struct Rotation: View {
    @State private var cameraRotation: Double = 0.0
    
    var body: some View {
        let plant = SceneView(scene: SCNScene(named: "Tree_average_bare.dae"), options: [.autoenablesDefaultLighting])
        
        VStack {
            Text("나무")
            plant
            Text("180도 회전")
        }
    }
}

struct Rotation_Previews: PreviewProvider {
    static var previews: some View {
        Rotation()
    }
}
