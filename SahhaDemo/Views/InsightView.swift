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
    
    @State var insights: [SahhaInsightIdentifier:[SahhaInsight]] = [:]
    
    func getInsightsForThisWeek() {
        let today = Date()
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: today) ?? Date()
        Sahha.getInsights(dates: (startDate: sevenDaysAgo, endDate: today)) { error, newInsights in
            if let error = error {
                print(error)
                return
            }
            for insightName in SahhaInsightIdentifier.allCases {
                insights[insightName] = []
            }
            for insight in newInsights {
                print(insight.name, insight.value, insight.unit, insight.startDate.toYMDFormat, insight.endDate.toYMDFormat)
                insights[insight.name]?.append(insight)
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
            ForEach(insights.sorted(by: { $0.key.rawValue < $1.key.rawValue }), id: \.key) { insightElement in
                ChartView(insightName: insightElement.key.rawValue, insights: insightElement.value)
            }
        }.onAppear(perform: {
            getInsightsForThisWeek()
        })
    }
}

#Preview {
    InsightView()
}

struct ChartView: View {
    
    @State var insightName: String = ""
    @State var insights: [SahhaInsight] = []
    
    var body: some View {
        Section(insightName) {
            Chart {
                ForEach(insights.sorted(by: { $0.startDate < $1.startDate }), id: \.name) { insight in
                    BarMark(
                        x: .value("Day", insight.startDate.formatted(Date.FormatStyle().weekday(.abbreviated))),
                        y: .value("Count", insight.value)
                    )
                }
            }.tint(.accentColor)
        }
    }
}
