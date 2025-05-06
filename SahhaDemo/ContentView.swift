// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha

struct ContentView: View {
    
    @State var sensorStatus: SahhaSensorStatus = .pending
    
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
                    Picker("Sensor Status", selection: .constant(sensorStatus.rawValue)) {
                        Text("Pending").tag(0)
                        Text("Unavailable").tag(1)
                        Text("Disabled").tag(2)
                        Text("Enabled").tag(3)
                    }.onAppear {
                        Sahha.getSensorStatus(Set(SahhaSensor.allCases)) { error, status in
                            sensorStatus = status
                        }
                    }
                    if sensorStatus == .pending {
                        Button {
                            Sahha.enableSensors(Set(SahhaSensor.allCases)) { error, status in
                                sensorStatus = status
                                print("Sahha | Sensor status:", sensorStatus.description)
                            }
                        } label: {
                            HStack {
                                Spacer()
                                Text("Enable")
                                Spacer()
                            }
                        }
                    } else {
                        Button {
                            Sahha.openAppSettings()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Open App Settings")
                                Spacer()
                            }
                        }
                    }
                }
                Section(header: Text("DATA")) {
                    NavigationLink {
                        WebView(url: URL(string: "https://sandbox-api.sahha.ai/api/v1/profile/integration/garmin/connect")!, profileToken: "profile " + (Sahha.profileToken ?? ""))
                            .ignoresSafeArea()
                            .navigationTitle("Garmin Connect")
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        HStack {
                            Image(systemName: "globe")
                            Text("Garmin Connect")
                        }
                    }
                    NavigationLink {
                        WebView(url: URL(string: "https://sandbox.webview.sahha.ai/app")!, profileToken: Sahha.profileToken)
                            .ignoresSafeArea()
                            .navigationTitle("Insights")
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        HStack {
                            Image(systemName: "wand.and.stars")
                            Text("Insights")
                        }
                    }
                    NavigationLink {
                        ScoreView()
                    } label: {
                        HStack {
                            Image(systemName: "brain.head.profile")
                            Text("Scores")
                        }
                    }
                    NavigationLink {
                        BiomarkerView()
                    } label: {
                        HStack {
                            Image(systemName: "doc.text.below.ecg")
                            Text("Biomarkers")
                        }
                    }
                    NavigationLink {
                        StatsView()
                    } label: {
                        HStack {
                            Image(systemName: "chart.xyaxis.line")
                            Text("Stats")
                        }
                    }
                    NavigationLink {
                        SamplesView()
                    } label: {
                        HStack {
                            Image(systemName: "clock.arrow.trianglehead.2.counterclockwise.rotate.90")
                            Text("Samples")
                        }
                    }
                    NavigationLink {
                        AppEventsView()
                    } label: {
                        HStack {
                            Image(systemName: "iphone.motion")
                            Text("App Events")
                        }
                    }
                }
                /*
                Section(header: Text("Surveys")) {
                    NavigationLink("TypeForm") {
                        WebView(url: URL(string: "https://p7g2dr2gsxx.typeform.com/to/uUNXxdxn#inference_id=ABC123")!)
                            .ignoresSafeArea()
                            .navigationTitle("TypeForm")
                            .navigationBarTitleDisplayMode(.inline)
                    }
                    NavigationLink("Tally") {
                        WebView(url: URL(string: "https://tally.so/r/mRMeG9?inference_id=ABC123")!)
                            .ignoresSafeArea()
                            .navigationTitle("Tally")
                            .navigationBarTitleDisplayMode(.inline)
                    }
                }
                Section(header: Text("Errors")) {
                    Button {
                        let body = "isProtectedDataAvailable : \(UIApplication.shared.isProtectedDataAvailable.description)"
                        Sahha.postError(message: "TEST", path: "content", method: "test", body: body)
                    } label: {
                        Text("ERROR")
                    }

                }
                 */
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

import WebKit

struct WebView: UIViewRepresentable {
    // 1
    let url: URL
    var profileToken: String?
    
    // 2
    func makeUIView(context: Context) -> WKWebView {
        
        return WKWebView()
    }
    
    // 3
    func updateUIView(_ webView: WKWebView, context: Context) {
        
        var request = URLRequest(url: url)
        if let token = profileToken {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }
        webView.load(request)
    }
}
