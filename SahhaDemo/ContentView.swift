// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Spacer()
                    Image("Icon").resizable().frame(width: 120, height: 120, alignment: .center)
                    Spacer()
                }
                Section(header: Text("PROFILE")) {
                    NavigationLink {
                        AuthenticationView()
                    } label: {
                        HStack {
                            Image(systemName: "lock.fill")
                            Text("Authentication")
                        }
                    }
                    NavigationLink {
                        DemographicView()
                    } label: {
                        HStack {
                            Image(systemName: "person.fill")
                            Text("Demographic")
                        }
                    }
                }
                Section(header: Text("SENSORS")) {
                    NavigationLink {
                        SleepView()
                    } label: {
                        HStack {
                            Image(systemName: "moon.zzz.fill")
                            Text("Sleep")
                        }
                    }
                    NavigationLink {
                        PedometerView()
                    } label: {
                        HStack {
                            Image(systemName: "figure.walk")
                            Text("Pedometer")
                        }
                    }
                }
                Section(header: Text("DATA")) {
                    NavigationLink {
                        AnalyzationView()
                    } label: {
                        HStack {
                            Image(systemName: "brain.head.profile")
                            Text("Analyzation")
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
