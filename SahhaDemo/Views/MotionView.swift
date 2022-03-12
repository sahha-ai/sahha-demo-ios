// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha

struct MotionView: View {

    @State var activityStatus: ActivityStatus = .unknown
    @State var isActivitySettingsPrompt: Bool = false
    
    var isActivityButtonDisabled: Bool {
        activityStatus == .unavailable || activityStatus == .enabled
    }
    
    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    Image(systemName: "figure.walk")
                    Text("Motion")
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
                    activityStatus = Sahha.motion.activityStatus
                }
            }
            Section {
                Button {
                    Sahha.motion.activate { newStatus in
                        activityStatus = newStatus
                        print("steps")
                        print(activityStatus.description)
                        switch activityStatus {
                        case .disabled:
                            isActivitySettingsPrompt = true
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
                }.disabled(isActivityButtonDisabled)
                    .alert(isPresented: $isActivitySettingsPrompt) {
                        Alert(
                            title: Text("Motion & Fitness"),
                            message: Text("Please enable this app to access your Motion & Fitness data"),
                            dismissButton: .default(Text("Open App Settings"), action: {
                                Sahha.motion.promptUserToActivate { activityStatus in
                                    print(activityStatus.description)
                                }
                            })
                        )
                    }
            }
        }
    }
}

struct MotionView_Previews: PreviewProvider {
    static var previews: some View {
        MotionView()
    }
}
