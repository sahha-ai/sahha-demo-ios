// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha

struct ScoreResponse: Codable {
    var id: String = UUID().uuidString
    var type: String = ""
    var state: String = ""
    var score: Double = 0.0
    var factors: [ScoreFactorResponse] = []
    var dataSources: [String] = []
    var scoreDateTime: String = ""
    var createdAtUtc: String = ""
}

struct ScoreFactorResponse: Codable {
    var id: String = UUID().uuidString
    var name: String? = ""
    var value: Double? = 0.0
    var goal: Double? = 0.0
    var score: Double? = 0.0
    var state: String? = ""
    var unit: String? = ""
}

struct ScoreView: View {
    
    @State var scoreString: String = ""
    @State var isAnalyzeButtonEnabled: Bool = true
    @State var scores: [ScoreResponse] = []
    
    func setScores(_ jsonString: String) {
        do {
            let jsonData = Data(jsonString.utf8)
            let jsonArray = try JSONDecoder().decode([ScoreResponse].self, from: jsonData)
            scores = jsonArray
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getScoresForToday() {
        scoreString = "Waiting..."
        isAnalyzeButtonEnabled = false
        Sahha.getScores([.activity]) { error, json in
            scoreString = ""
            isAnalyzeButtonEnabled = true
            if let error = error {
                print(error)
            }
            else if let json = json {
                print(json)
                //scoreString = json
                setScores(json)
            }
        }
    }
    
    func getScoresForThisWeek() {
        scoreString = "Waiting..."
        let today = Date()
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: today) ?? Date()
        Sahha.getScores([.activity], dates: (sevenDaysAgo, today)) { error, json in
            scoreString = ""
            isAnalyzeButtonEnabled = true
            if let error = error {
                print(error)
            }
            else if let json = json {
                print(json)
                //scoreString = json
                setScores(json)
            }
        }
    }
    
    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    Image(systemName: "brain.head.profile")
                    Text("Scores")
                    Spacer()
                }.font(.title)
            }
            Section {
                Text("A new score will be available every 6 hours. If a score is empty {}, it means more sensor data must be collected. Try again in 6 hours. ").font(.caption).multilineTextAlignment(.center)
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
            ForEach(scores, id: \.id) { score in
                Section {
                    VStack(alignment: .leading) {
                        Text("scoreDateTime")
                        Text(score.scoreDateTime)
                    }
                    VStack(alignment: .leading) {
                        Text("type")
                        Text(score.type)
                    }
                    VStack(alignment: .leading) {
                        Text("state")
                        Text(score.state)
                    }
                    VStack(alignment: .leading) {
                        Text("score")
                        Text("\(score.score)")
                    }
                } header: {
                    Text(UUID().uuidString)
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
            } else if scores.isEmpty {
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
    """)
                    }
                } header : {
                    HStack {
                        Spacer()
                        Text("Sample Analysis")
                        Spacer()
                    }
                }
            }
        }.font(.caption)
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView()
    }
}
