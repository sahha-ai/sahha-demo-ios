// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha

@main
struct SahhaDemoApp: App {
    
    init() {
        let settings = SahhaSettings(environment: .sandbox)
        Sahha.configure(settings)
        UITextField.appearance().clearButtonMode = .whileEditing
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
