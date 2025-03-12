//
//  SamplesView.swift
//  SahhaDemo
//
//  Created by Matthew on 2024-11-20.
//

import SwiftUI
import Sahha

public extension SahhaSample {
    var stringValue: String {
        return String(format: "%g", value)
    }
}

struct SamplesView: View {
    
    let sensors: [SahhaSensor] = SahhaSensor.allCases
    @State private var samples: [SahhaSensor: [SahhaSample]] = [:]
    @State private var selectionDate: Date = Date()
    
    func getSamples() {
        self.samples = [:]
        let startDate = Calendar.current.startOfDay(for: selectionDate)
        var endDate = Calendar.current.date(byAdding: .day, value: 1, to: selectionDate) ?? selectionDate
        endDate = Calendar.current.startOfDay(for: endDate)
        for sensor in sensors {
            Sahha.getSamples(sensor: sensor, startDateTime: startDate, endDateTime: endDate) { error, newSamples in
                if let error = error {
                    print(error)
                }
                if newSamples.isEmpty == false {
                    samples[sensor] = newSamples
                }
            }
        }
    }
    
    func displaySampleTime(_ sample: SahhaSample) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .short
        let dateComponents = DateComponents(hour: 0, minute: Int(sample.value))
        if let formattedString = formatter.string(from: dateComponents) {
            return formattedString
        } else {
            return "\(sample.stringValue) \(sample.unit)"
        }
    }
    
    func createStatsList(sample: SahhaSample) -> some View {
        NavigationLink {
            StatsList(stats: sample.stats).navigationTitle("Stats")
        } label: {
            createSampleView(sample: sample)
        }
    }
    
    func createSampleView(sample: SahhaSample) -> some View {
        VStack(alignment: .leading) {
            Text(sample.startDateTime.toString)
            Text(sample.category)
            HStack {
                Text(sample.type).bold()
                Spacer()
                if sample.type.hasPrefix("sleep") || sample.type.hasPrefix("exercise") {
                    Text(displaySampleTime(sample)).bold()
                } else {
                    Text("\(sample.stringValue) \(sample.unit)").bold()
                }
            }
            Text(sample.recordingMethod)
            Text(sample.source)
            Text(sample.endDateTime.toString)
        }.font(.caption).navigationTitle(selectionDate.toYMDFormat)
    }
    
    var body: some View {
        VStack {
            DatePicker(
                "Samples Date",
                selection: $selectionDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical).padding()
            
            Spacer()
                        
            Button("Refresh") {
                
                getSamples()
                
            }
            
            Spacer()
            
            List {
                ForEach(Array(samples.keys), id: \.self) { key in
                    NavigationLink {
                        List {
                            ForEach(samples[key]!, id: \.id) { sample in
                                if sample.stats.isEmpty {
                                    createSampleView(sample: sample)
                                } else {
                                    createStatsList(sample: sample)
                                }
                            }
                        }
                    } label: {
                        VStack {
                            Text(key.rawValue).font(.caption).bold()
                        }
                    }
                }
            }.scrollContentBackground(.hidden)
            
        }.onAppear {
            getSamples()
        }.onChange(of: selectionDate) { _ in
            getSamples()
        }.navigationTitle("Daily Samples")
    }
}

#Preview {
    SamplesView()
}
