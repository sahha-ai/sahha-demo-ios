//
//  StatsView.swift
//  SahhaDemo
//
//  Created by Matthew on 2024-11-20.
//

import SwiftUI
import Sahha

public extension SahhaStat {
    var stringValue: String {
        return String(format: "%g", value)
    }
}

func displayStatTime(_ stat: SahhaStat) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute]
    formatter.unitsStyle = .short
    let dateComponents = DateComponents(hour: 0, minute: Int(stat.value))
    if let formattedString = formatter.string(from: dateComponents) {
        return formattedString
    } else {
        return "\(stat.stringValue) \(stat.unit)"
    }
}

func createStatView(stat: SahhaStat) -> some View {
    VStack {
        HStack {
            Text(stat.category)
            Spacer()
        }
        HStack {
            Text(stat.type).bold()
            Spacer()
            if stat.type.hasPrefix("sleep") || stat.type.hasPrefix("exercise") {
                Text(displayStatTime(stat))
            } else {
                Text("\(stat.stringValue) \(stat.unit)")
            }
        }
    }.font(.caption)
}

struct StatsList: View {
    
    var stats: [SahhaStat]
    
    var body: some View {
        List {
            ForEach(stats, id: \.id) { stat in
                createStatView(stat: stat)
            }
        }.scrollContentBackground(.hidden)
    }
}

struct StatsView: View {
    
    let sensors: [SahhaSensor] = SahhaSensor.allCases
    @State private var stats: [SahhaStat] = []
    @State private var selectionDate: Date = Date()
    
    func getStats() {
        self.stats = []
        for sensor in sensors {
            Sahha.getStats(sensor: sensor, startDateTime: selectionDate, endDateTime: selectionDate) { error, newStats in
                self.stats.append(contentsOf: newStats)
                print(newStats)
            }
        }
    }
    
    var body: some View {
        VStack {
            DatePicker(
                "Stats Date",
                selection: $selectionDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical).padding()
            
            Spacer()
            
            StatsList(stats: stats)
            
        }.onAppear {
            getStats()
        }.onChange(of: selectionDate) { _ in
            getStats()
        }.navigationTitle("Daily Stats")
    }
}

#Preview {
    StatsView()
}
