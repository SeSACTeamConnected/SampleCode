//
//  ContentView.swift
//  RotationTutorial
//
//  Created by Nayeon Kim on 2023/05/31.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
            .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
