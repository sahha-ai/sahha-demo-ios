//
//  BiomarkerView.swift
//  SahhaDemo
//
//  Created by Hee-Min Chae on 27/11/2024.
//  Copyright © 2024 Sahha. All rights reserved.
//

import SwiftUI
import Sahha

struct BiomarkerView: View {
    
    @State var biomarkerString: String = ""
    @State var isAnalyzeButtonEnabled: Bool = true
    
    func getBiomarkersForToday() {
        biomarkerString = "Waiting..."
        isAnalyzeButtonEnabled = false
        Sahha.getBiomarkers(
            categories: [.activity, .sleep, .vitals],
            types: [.steps, .sleep_duration, .heart_rate_sleep, .heart_rate_resting]
        ) { error, json in
            isAnalyzeButtonEnabled = true
            if let error = error {
                print(error)
            }
            else if let json = json {
                print(json)
                biomarkerString = json
            }
        }
    }
    
    func getBiomarkersForThisWeek() {
        biomarkerString = "Waiting..."
        let today = Date()
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: today) ?? Date()
        Sahha.getBiomarkers(
            categories: [.activity, .sleep, .vitals],
            types: [.steps, .sleep_duration, .heart_rate_sleep, .heart_rate_resting],
            dates: (sevenDaysAgo, today)
        ) { error, json in
            isAnalyzeButtonEnabled = true
            if let error = error {
                print(error)
            }
            else if let json = json {
                print(json)
                biomarkerString = json
            }
        }
    }
    
    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    Image(systemName: "doc.text.below.ecg")
                    Text("Biomarkers")
                    Spacer()
                }.font(.title)
            }
            Section {
                Text("A new score will be available every 6 hours. If a score is empty {}, it means more sensor data must be collected. Try again in 6 hours. ").font(.caption).multilineTextAlignment(.center)
            }
            if isAnalyzeButtonEnabled {
                Section {
                    Button {
                        getBiomarkersForToday()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Check Previous 24 Hours")
                            Spacer()
                        }
                    }
                }
                Section {
                    Button {
                        getBiomarkersForThisWeek()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Check Previous Week")
                            Spacer()
                        }
                    }
                }
            }
            if biomarkerString.isEmpty == false {
                Section {
                    ScrollView(.horizontal) {
                        Text(biomarkerString).font(.caption)
                    }
                } header : {
                    HStack {
                        Spacer()
                        Text("Biomarker")
                        Spacer()
                    }
                }
            } else {
                Section {
                    ScrollView(.horizontal) {
                        Text("""
    {
        "inferences": [
            {
                "createdAt": "2022-06-09T00:30:00+00:00",
                "modelName": "automl_toolkit_randomForest",
                "predictionState": "not_depressed",
                "predictionSubState": "",
                "predictionRange": -1,
                "predictionConfidence": 0.8,
                "dataSource": [
                    "sleep",
                    "screenTime"
                ]
            }
        ]
    }
    """).font(.caption)
                    }
                } header : {
                    HStack {
                        Spacer()
                        Text("Sample Analysis")
                        Spacer()
                    }
                }
            }
        }
    }
}

struct BiomarkerView_Previews: PreviewProvider {
    static var previews: some View {
        BiomarkerView()
    }
}
