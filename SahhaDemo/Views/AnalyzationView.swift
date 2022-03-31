// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha

struct AnalyzationView: View {
    
    @State var analyzationString: String = ""
    @State var isAnalyzeButtonEnabled: Bool = true
        
    func getAnalyzation() {
        analyzationString = "Waiting..."
        isAnalyzeButtonEnabled = false
        Sahha.analyze { error, string in
            isAnalyzeButtonEnabled = true
            if let error = error {
                print(error)
            }
            else if let string = string {
                analyzationString = string
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
                        getAnalyzation()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Analyze")
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
