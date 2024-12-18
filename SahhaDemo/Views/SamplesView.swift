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
        for sensor in sensors {
            Sahha.getSamples(sensor: sensor, startDate: startDate, endDate: selectionDate) { error, newSamples in
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
    
    func createSampleView(sample: SahhaSample) -> some View {
        VStack(alignment: .leading) {
            Text(sample.startDate.toString)
            HStack {
                Text(sample.type).bold()
                Spacer()
                if sample.type.hasPrefix("sleep") || sample.type.hasPrefix("exercise") {
                    Text(displaySampleTime(sample)).bold()
                } else {
                    Text("\(sample.stringValue) \(sample.unit)").bold()
                }
            }
            Text(sample.endDate.toString)
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
            
            List {
                ForEach(Array(samples.keys), id: \.self) { key in
                    NavigationLink {
                        List {
                            ForEach(samples[key]!, id: \.id) { sample in
                                createSampleView(sample: sample)
                            }
                        }
                    } label: {
                        Text(key.rawValue).font(.caption)
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
