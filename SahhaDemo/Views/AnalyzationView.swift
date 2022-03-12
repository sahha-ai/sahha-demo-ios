// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha

struct AnalyzationView: View {
    
    @State var isAnalyzeButtonEnabled: Bool = true
        
    var sampleString: String = """
\nid :
kYJk8CCasUeHTz5rvSc9Yw
    \ncreated_at :
2022-01-19T21:50:27.564Z
    \nstate :
depressed
    \nsub_state :
moderate
    \nrange :
7
    \nconfidence :
0.91
    \nphenotypes : [
        \tscreen_time
        \tsleep
    ]
\n
"""
    
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
                        //Sahha.analyze()
                        isAnalyzeButtonEnabled.toggle()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Analyze")
                            Spacer()
                        }
                    }
                }
            } else {
                Section {
                    Text(sampleString).font(.caption)
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
