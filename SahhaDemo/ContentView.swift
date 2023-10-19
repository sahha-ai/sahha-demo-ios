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
                        AnalysisView()
                    } label: {
                        HStack {
                            Image(systemName: "brain.head.profile")
                            Text("Analysis")
                        }
                    }
                }
                Section(header: Text("INSIGHTS")) {
                    NavigationLink {
                        InsightView()
                    } label: {
                        HStack {
                            Image(systemName: "chart.xyaxis.line")
                            Text("Insights")
                        }
                    }
                }
                Section(header: Text("Surveyrs")) {
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
    
    
    // 2
    func makeUIView(context: Context) -> WKWebView {
        
        return WKWebView()
    }
    
    // 3
    func updateUIView(_ webView: WKWebView, context: Context) {
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
