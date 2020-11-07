//
//  ContentView.swift
//  gloop-drop
//
//  Created by Fernando Fernandes on 18.09.20.
//

import SwiftUI

struct ContentView: View {

    // MARK: - Properties

    var body: some View {
        MainSceneView()
            .edgesIgnoringSafeArea(.all)
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
