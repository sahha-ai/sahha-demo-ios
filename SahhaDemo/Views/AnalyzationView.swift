// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha

struct AnalyzationView: View {
    
    var isAnalyzeButtonDisabled: Bool {
        false
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
                Button {
                    Sahha.analyze()
                } label: {
                    HStack {
                        Spacer()
                        Text("Analyze")
                        Spacer()
                    }
                }.disabled(isAnalyzeButtonDisabled)
            }
        }
    }
}

struct AnalyzationView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyzationView()
    }
}
