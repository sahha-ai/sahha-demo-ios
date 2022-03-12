// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha

@main
struct SahhaDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().onAppear {
                Sahha.configure()
            }
        }
    }
}
