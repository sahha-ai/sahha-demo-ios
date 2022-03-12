// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha

struct HealthView: View {
    
    @State var activityStatus: ActivityStatus = .unknown
    
    var isActivityButtonDisabled: Bool {
        activityStatus == .unavailable || activityStatus == .enabled
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
                Picker("Activity Status", selection: .constant(activityStatus.rawValue)) {
                    Text("Unknown").tag(0)
                    Text("Unavailable").tag(1)
                    Text("Disabled").tag(2)
                    Text("Enabled").tag(3)
                }.onAppear {
                    activityStatus = Sahha.health.activityStatus
                }
            }
            Section {
                Button {
                    Sahha.health.activate {  newStatus in
                        activityStatus = newStatus
                        print("sleep")
                        print(activityStatus.description)
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Enable")
                        Spacer()
                    }
                }.disabled(isActivityButtonDisabled)
            }
        }
    }
}

struct HealthView_Previews: PreviewProvider {
    static var previews: some View {
        HealthView()
    }
}
