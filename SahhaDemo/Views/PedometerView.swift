// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha

struct PedometerView: View {
    
    @State var sensorStatus: SahhaSensorStatus = .pending
    @State var isSensorSettingsPrompt: Bool = false
    
    var isActivityButtonEnabled: Bool {
        sensorStatus == .pending || sensorStatus == .disabled
    }
    
    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    Image(systemName: "figure.walk")
                    Text("Pedometer")
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
                    Sahha.getSensorStatus(.pedometer) { newStatus in
                        sensorStatus = newStatus
                    }
                }
            }
            if isActivityButtonEnabled {
                Section {
                    Button {
                        Sahha.enableSensor(.pedometer) { newStatus in
                            sensorStatus = newStatus
                            print(sensorStatus.description)
                            switch sensorStatus {
                            case .disabled:
                                isSensorSettingsPrompt = true
                            default:
                                break
                            }
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text("Enable")
                            Spacer()
                        }
                    }
                    .alert(isPresented: $isSensorSettingsPrompt) {
                        Alert(
                            title: Text("Motion & Fitness"),
                            message: Text("Please enable this app to access your Motion & Fitness data"),
                            dismissButton: .default(Text("Open App Settings"), action: {
                                Sahha.openAppSettings()
                            })
                        )
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

struct PedometerView_Previews: PreviewProvider {
    static var previews: some View {
        PedometerView()
    }
}
