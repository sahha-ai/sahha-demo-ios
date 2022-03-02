// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha

struct ContentView: View {
    var body: some View {
        VStack {
        Text(Sahha.shared.bundleId)
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
