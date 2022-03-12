// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha

struct MotionHistoryView: View {
    var body: some View {
        List {
            Section {
                ForEach(Sahha.motion.activityHistory, id: \.self) { item in
                    VStack {
                        Text(item.startDate.toDateTimeFormat)
                        HStack {
                            Spacer()
                            Image(systemName: "figure.walk")
                            Text("\(item.numberOfSteps) steps")
                            Spacer()
                        }
                        Text(item.endDate.toDateTimeFormat)
                    }.frame(minWidth: 0, maxWidth: .infinity)
                }
            } header : {
                HStack {
                    Spacer()
                    Image(systemName: "calendar")
                    Text("7 Day Snapshot").bold()
                    Spacer()
                }
            }
        }.navigationTitle("Activity History")
            .font(.caption)
            .multilineTextAlignment(.center)
    }
}

struct MotionHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        MotionHistoryView()
    }
}
