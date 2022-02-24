//
//  ContentView.swift
//  SahhaExample
//
//  Created by Matthew on 2/10/22.
//

import SwiftUI
import Sahha

struct ContentView: View {
    var body: some View {
        VStack {
        Text(Sahha.shared.bundleId)
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
