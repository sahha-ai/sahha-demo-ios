// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha

struct ScoreView: View {
    
    @State var scoreString: String = ""
    @State var isAnalyzeButtonEnabled: Bool = true
    
    func getScoresForToday() {
        scoreString = "Waiting..."
        isAnalyzeButtonEnabled = false
        Sahha.getScores([.activity, .sleep, .readiness, .wellbeing, .mental_wellbeing]) { error, json in
            isAnalyzeButtonEnabled = true
            if let error = error {
                print(error)
            }
            else if let json = json {
                print(json)
                scoreString = json
            }
        }
    }
    
    func getScoresForThisWeek() {
        scoreString = "Waiting..."
        let today = Date()
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: today) ?? Date()
        Sahha.getScores([.activity, .sleep, .readiness, .wellbeing, .mental_wellbeing], dates: (sevenDaysAgo, today)) { error, json in
            isAnalyzeButtonEnabled = true
            if let error = error {
                print(error)
            }
            else if let json = json {
                print(json)
                scoreString = json
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
                Text("A new score will be available every 24 hours. If a score is empty {}, it means more sensor data must be collected. Try again in 24 hours. ").font(.caption).multilineTextAlignment(.center)
            }
            if isAnalyzeButtonEnabled {
                Section {
                    Button {
                        getScoresForToday()
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
                        getScoresForThisWeek()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Check Previous Week")
                            Spacer()
                        }
                    }
                }
            }
            if scoreString.isEmpty == false {
                Section {
                    ScrollView(.horizontal) {
                        Text(scoreString).font(.caption)
                    }
                } header : {
                    HStack {
                        Spacer()
                        Text("Score")
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

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView()
    }
}
