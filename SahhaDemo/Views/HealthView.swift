// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha

struct HealthView: View {
    
    @State var activityStatus: SahhaActivityStatus = .pending
    
    var isActivityButtonEnabled: Bool {
        activityStatus == .pending || activityStatus == .disabled
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
                    Text("Pending").tag(0)
                    Text("Unavailable").tag(1)
                    Text("Disabled").tag(2)
                    Text("Enabled").tag(3)
                }.onAppear {
                    activityStatus = Sahha.health.activityStatus
                }
            }
            if isActivityButtonEnabled {
                Section {
                    Button {
                        Sahha.health.activate {  newStatus in
                            activityStatus = newStatus
                            print("Sahha | Health activity status: ", activityStatus.description)
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text("Enable")
                            Spacer()
                        }
                    }
                }
            }
            if activityStatus == .enabled {
                Section {
                    NavigationLink {
                        HealthHistoryView()
                    } label: {
                        HStack {
                            Image(systemName: "clock")
                            Text("Activity History").bold()
                        }
                    }
                }
            }
        }
    }
}

struct HealthView_Previews: PreviewProvider {
    static var previews: some View {
        HealthView()
    }
}
