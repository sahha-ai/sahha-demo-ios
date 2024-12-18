//
//  StatsView.swift
//  SahhaApp
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

struct StatsView: View {
    
    var sensors: [SahhaSensor] = [.steps, .floors_climbed, .heart_rate, .heart_rate_variability_sdnn, .vo2_max, .oxygen_saturation, .active_energy_burned, .sleep]
    @State private var stats: [SahhaStat] = []
    @State private var selectionDate: Date = Date()
    
    func getStats() {
        self.stats = []
        for sensor in sensors {
            Sahha.getStats(sensor: sensor, startDate: selectionDate, endDate: selectionDate) { error, newStats in
                self.stats.append(contentsOf: newStats)
            }
        }
    }
    
    func displaySleepTime(_ stat: SahhaStat) -> String {
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
                Text(stat.type)
                Spacer()
                switch stat.type {
                case "sleep",
                    "sleep_stage_unknown",
                "sleep_stage_in_bed", "sleep_stage_light", "sleep_stage_deep", "sleep_stage_sleeping",
                "sleep_stage_awake",
                    "sleep_stage_rem":
                    Text(displaySleepTime(stat))
                default:
                    Text("\(stat.stringValue) \(stat.unit)")
                }
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
            
            List {
                ForEach(stats, id: \.id) { stat in
                    createStatView(stat: stat)
                }
            }.scrollContentBackground(.hidden)
            
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
