//
//  InsightView.swift
//  SahhaDemo
//
//  Created by Matthew on 10/9/23.
//  Copyright © 2023 Sahha. All rights reserved.
//

import SwiftUI
import Sahha
import Charts

struct InsightView: View {
    
    @State var movementInsights: [SahhaInsight] = []
    @State var bedInsights: [SahhaInsight] = []
    @State var sleepInsights: [SahhaInsight] = []
    
    func getInsightsForThisWeek() {
        let today = Date()
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -6, to: today) ?? Date()
        Sahha.getInsights(dates: (startDate: sevenDaysAgo, endDate: today)) { error, newInsights in
            if let error = error {
                print(error)
            }
            movementInsights = []
            bedInsights = []
            sleepInsights = []
            for insight in newInsights {
                print(insight.name, insight.endDate.toYMDFormat, insight.value)
                if insight.name == "StepCountDailyTotal" {
                    movementInsights.append(insight)
                } else if insight.name == "TimeInBedDailyTotal" {
                    bedInsights.append(insight)
                } else if insight.name == "TimeAsleepDailyTotal" {
                    sleepInsights.append(insight)
                }
            }

        }
    }
    
    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    Image(systemName: "chart.xyaxis.line")
                    Text("Insights")
                    Spacer()
                }.font(.title)
            }
            Section("Step Count") {
                Chart {
                    ForEach(movementInsights, id: \.name) { insight in
                        BarMark(
                            x: .value("Day", insight.startDate.formatted(Date.FormatStyle().weekday(.abbreviated))),
                            y: .value("Count", insight.value)
                        )
                    }
                }.tint(.accentColor)
            }
            Section("Time in Bed") {
                Chart {
                    ForEach(bedInsights, id: \.name) { insight in
                        BarMark(
                            x: .value("Day", insight.startDate.formatted(Date.FormatStyle().weekday(.abbreviated))),
                            y: .value("Count", insight.value)
                        )
                    }
                }.tint(.accentColor)
            }
            Section("Time Asleep") {
                Chart {
                    ForEach(sleepInsights, id: \.name) { insight in
                        BarMark(
                            x: .value("Day", insight.startDate.formatted(Date.FormatStyle().weekday(.abbreviated))),
                            y: .value("Count", insight.value)
                        )
                    }
                }.tint(.accentColor)
            }
        }.onAppear(perform: {
            getInsightsForThisWeek()
        })
    }
}

#Preview {
    InsightView()
}
