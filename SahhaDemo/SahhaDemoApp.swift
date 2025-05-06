// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha
import BackgroundTasks

@main
struct SahhaDemoApp: App {
    @Environment(\.scenePhase) private var phase
    
    init() {
        let settings = SahhaSettings(environment: .sandbox)
        Sahha.configure(settings)
        UITextField.appearance().clearButtonMode = .whileEditing
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "demo.sahha.ios")
        try? BGTaskScheduler.shared.submit(request)
        print("Schedule app refresh")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }.onChange(of: phase) { newPhase in
            switch newPhase {
            case .background:
                scheduleAppRefresh()
            default: break
            }
        }.backgroundTask(.appRefresh("demo.sahha.ios")) {
            print("Handle app refresh")
            Sahha.postSensorData()
            await scheduleAppRefresh()
        }
    }
}
