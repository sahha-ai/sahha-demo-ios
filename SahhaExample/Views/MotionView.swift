// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha

struct MotionView: View {

    @State private var isActivitySettingsPrompt: Bool = false
    
    var isActivityButtonDisabled: Bool {
        Sahha.motion.activityStatus == .unavailable || Sahha.motion.activityStatus == .enabled
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
                Picker("Activity Status", selection: .constant(Sahha.motion.activityStatus.rawValue)) {
                    Text("Unknown").tag(0)
                    Text("Unavailable").tag(1)
                    Text("Disabled").tag(2)
                    Text("Enabled").tag(3)
                }
            }
            Section {
                Button("Enable") {
                    Sahha.motion.activate { activityStatus in
                        print("steps")
                        print(activityStatus.description)
                        switch activityStatus {
                        case .disabled:
                            isActivitySettingsPrompt = true
                        default:
                            break
                        }
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
