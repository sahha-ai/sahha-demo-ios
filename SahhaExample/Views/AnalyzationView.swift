// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI

struct AnalyzationView: View {
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
        }
    }
}

struct AnalyzationView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyzationView()
    }
}
