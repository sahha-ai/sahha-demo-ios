// Copyright © 2022 Sahha. All rights reserved.

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
