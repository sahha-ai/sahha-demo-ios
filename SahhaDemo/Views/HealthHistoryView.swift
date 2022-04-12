// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha
import HealthKit

struct HealthHistoryView: View {
    var body: some View {
        List {
            Section {
                ForEach(Sahha.health.activityHistory, id: \.self) { item in
                    VStack {
                        Text(item.startDate.toDateTimeFormat)
                        HStack {
                            Spacer()
                            Group {
                                if item.value == HKCategoryValueSleepAnalysis.inBed.rawValue {
                                    Image(systemName: "bed.double.fill")
                                    Text("In Bed")
                                } else if item.value == HKCategoryValueSleepAnalysis.asleep.rawValue {
                                    Image(systemName: "moon.zzz.fill")
                                    Text("Asleep")
                                } else if item.value == HKCategoryValueSleepAnalysis.awake.rawValue {
                                    Image(systemName: "sun.max.fill")
                                    Text("Awake")
                                }
                            }
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
