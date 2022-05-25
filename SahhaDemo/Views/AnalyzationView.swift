// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha

struct AnalyzationView: View {
    
    @State var analyzationString: String = ""
    @State var isAnalyzeButtonEnabled: Bool = true
        
    func getAnalyzationForToday() {
        analyzationString = "Waiting..."
        isAnalyzeButtonEnabled = false
        Sahha.analyze { error, json in
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
        Sahha.analyze(dates: (sevenDaysAgo, today)) { error, json in
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
            if isAnalyzeButtonEnabled {
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
                    Text(analyzationString).font(.caption)
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
