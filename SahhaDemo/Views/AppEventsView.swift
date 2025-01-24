//
//  StatsView.swift
//  SahhaDemo
//
//  Created by Matthew on 2024-11-20.
//

import SwiftUI
import Sahha

struct AppEventsView: View {

    @State private var selectionDate: Date = Date()
    @State private var appEvents: [String] = []
    
    func getAppEvents() {
         let today = selectionDate.toYYYYMMDD
         let keyName = "app_events_" + today
         let strings = UserDefaults.standard.stringArray(forKey: keyName) ?? []
        appEvents = strings
     }
    
    var body: some View {
        VStack {
            DatePicker(
                "Stats Date",
                selection: $selectionDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical).padding()
            
            Spacer()
            
            List {
                ForEach(appEvents, id: \.self) { appEvent in
                    Text(appEvent)
                }
            }.scrollContentBackground(.hidden).font(.caption)
            
        }.onAppear {
            getAppEvents()
        }.onChange(of: selectionDate) { _ in
            getAppEvents()
        }.navigationTitle("Daily App Events")
    }
}

#Preview {
    AppEventsView()
}
