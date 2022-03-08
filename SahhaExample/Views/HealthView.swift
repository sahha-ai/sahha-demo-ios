// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha

struct HealthView: View {
    
    var isActivityDisabled: Bool {
        Sahha.health.activityStatus == .unavailable || Sahha.health.activityStatus == .enabled
    }
    
    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    Image(systemName: "heart.fill")
                    Text("Health")
                    Spacer()
                }.font(.title)
            }
            Section {
                Picker("Activity Status", selection: .constant(Sahha.health.activityStatus.rawValue)) {
                    Text("Unknown").tag(0)
                    Text("Unavailable").tag(1)
                    Text("Disabled").tag(2)
                    Text("Enabled").tag(3)
                }
            }
            Section {
                Button("Enable") {
                    Sahha.health.activate { activityStatus in
                        print(activityStatus.description)
                    }
                }.disabled(isActivityDisabled)
            }
        }
    }
}

struct HealthView_Previews: PreviewProvider {
    static var previews: some View {
        HealthView()
    }
}
