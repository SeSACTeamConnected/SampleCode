//
//  ContentView.swift
//  TestScene
//
//  Created by 김다빈 on 2023/05/30.
//

import SwiftUI
import SceneKit

struct ContentView: View {
    var body: some View {
        VStack {
           Home()
            
          
        }
    }
}

struct Home : View {
    @State var models = [
        Model(id: 1, name: "uploads_files_3255476_Double+Hot+Chocolate", modelName: "uploads_files_3255476_Double+Hot+Chocolate.usdz"),
        Model(id: 0, name: "uploads_files_3247135_Nuttella_Latte", modelName: "uploads_files_3247135_Nuttella_Latte.usdz")
        
    ]
    @State var index = 0
    var body: some View{
        VStack{
            SceneView(scene: SCNScene(named: models[index].modelName),options: [.autoenablesDefaultLighting,.allowsCameraControl])
            Button {
                index += 1
                print(models[index].modelName)
            } label: {
                Text("test")
            }

        }
        
    }
}
struct Model : Identifiable {
    var id : Int
    var name: String
    var modelName : String
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
