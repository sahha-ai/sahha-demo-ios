//
//  SahhaExampleApp.swift
//  SahhaExample
//
//  Created by Matthew on 2/10/22.
//

import SwiftUI
import Sahha

@main
struct SahhaExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().onAppear {
                Sahha.shared.setup()
            }
        }
    }
}
