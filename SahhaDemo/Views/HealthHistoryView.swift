// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha

struct HealthHistoryView: View {
    var body: some View {
        List {
            Section {
                ForEach(Sahha.health.activityHistory, id: \.self) { item in
                    VStack {
                        Text(item.startDate.toDateTimeFormat)
                        HStack {
                            Spacer()
                            if item.isAsleep {
                                Text("Asleep")
                                Image(systemName: "moon.zzz.fill")
                            } else {
                                Text("In Bed")
                                Image(systemName: "bed.double.fill")
                            }
                            Text("\(item.count) minutes")
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

struct HealthHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HealthHistoryView()
    }
}
