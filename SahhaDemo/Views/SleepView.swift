// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha

struct SleepView: View {
    
    @State var sensorStatus: SahhaSensorStatus = .pending
    
    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    Image(systemName: "moon.zzz.fill")
                    Text("Sleep")
                    Spacer()
                }.font(.title)
            }
            Section {
                Picker("Sensor Status", selection: .constant(sensorStatus.rawValue)) {
                    Text("Pending").tag(0)
                    Text("Unavailable").tag(1)
                    Text("Disabled").tag(2)
                    Text("Enabled").tag(3)
                }.onAppear {
                    Sahha.getSensorStatus { newStatus in
                        sensorStatus = newStatus
                    }
                }
            }
            if sensorStatus == .pending {
                Section {
                    Button {
                        Sahha.enableSensors { newStatus in
                            sensorStatus = newStatus
                            print("Sahha | Sleep sensor status: ", sensorStatus.description)
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text("Enable")
                            Spacer()
                        }
                    }
                }
            } else {
                Section {
                    Button {
                        Sahha.openAppSettings()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Open App Settings")
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

struct SleepView_Previews: PreviewProvider {
    static var previews: some View {
        SleepView()
    }
}
