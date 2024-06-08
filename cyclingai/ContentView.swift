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
                        Sahha.getSensorStatus { error, status in
                            sensorStatus = status
                        }
                    }
                    if sensorStatus == .pending {
                        Button {
                            Sahha.enableSensors { error, status in
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
                        Button {
                            //Sahha.testData()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Test Data")
                                Spacer()
                            }
                        }
                    }
                }
                Section(header: Text("DATA")) {
                    NavigationLink {
                        AnalysisView()
                    } label: {
                        HStack {
                            Image(systemName: "brain.head.profile")
                            Text("Analysis")
                        }
                    }
                    NavigationLink {
                        WebView(url: URL(string: "https://webview.sahha.ai/app")!, profileToken: Sahha.profileToken)
                            .ignoresSafeArea()
                            .navigationTitle("Insights")
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        HStack {
                            Image(systemName: "wand.and.stars")
                            Text("Insights")
                        }
                    }
                }
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
            request.setValue(token, forHTTPHeaderField: "AUTH")
        }
        webView.load(request)
    }
}
