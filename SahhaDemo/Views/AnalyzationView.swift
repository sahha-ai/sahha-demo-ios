// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha

struct AnalyzationView: View {
    
    @State var analyzationString: String = ""
    @State var isAnalyzeButtonEnabled: Bool = true
    @AppStorage("isincludeSourceData") var isincludeSourceData: Bool = false
    
    func getAnalyzationForToday() {
        analyzationString = "Waiting..."
        isAnalyzeButtonEnabled = false
        Sahha.analyze(includeSourceData: isincludeSourceData) { error, json in
            isAnalyzeButtonEnabled = true
            if let error = error {
                print(error)
            }
            else if let json = json {
                print(json)
                analyzationString = json
            }
        }
    }
    
    func getAnalyzationForThisWeek() {
        analyzationString = "Waiting..."
        let today = Date()
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: today) ?? Date()
        Sahha.analyze(dates: (sevenDaysAgo, today), includeSourceData: isincludeSourceData) { error, json in
            isAnalyzeButtonEnabled = true
            if let error = error {
                print(error)
            }
            else if let json = json {
                print(json)
                analyzationString = json
            }
        }
    }
    
    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    Image(systemName: "brain.head.profile")
                    Text("Analyzation")
                    Spacer()
                }.font(.title)
            }
            Section {
                Text("A new analysis will be available every 24 hours. If an analysis is empty {}, it means more sensor data must be collected. Try again in 24 hours. ").font(.caption).multilineTextAlignment(.center)
            }
            if isAnalyzeButtonEnabled {
                Section {
                    Text("Include a list of the source data used to generate the analysis?").font(.caption)
                    Toggle("Include Source Data", isOn: $isincludeSourceData)
                }
                Section {
                    Button {
                        getAnalyzationForToday()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Analyze Previous 24 Hours")
                            Spacer()
                        }
                    }
                }
                Section {
                    Button {
                        getAnalyzationForThisWeek()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Analyze Previous Week")
                            Spacer()
                        }
                    }
                }
            }
            if analyzationString.isEmpty == false {
                Section {
                    ScrollView(.horizontal) {
                        Text(analyzationString).font(.caption)
                    }
                } header : {
                    HStack {
                        Spacer()
                        Text("Analysis")
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

struct AnalyzationView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyzationView()
    }
}
