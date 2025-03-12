//
//  ContentView.swift
//  watch Watch App
//
//  Created by Matthew on 2025-02-27.
//  Copyright © 2025 Sahha. All rights reserved.
//

import SwiftUI
import HealthKit

struct ContentView: View, HKLiveWorkoutBuilderDelegate {
    
    @State var isHealthEnabled: Bool = false
    @State var isWorkoutActive: Bool = false
    let healthStore = HKHealthStore()
    
    // The quantity type to write to the health store.
    let typesToShare: Set = [
        HKQuantityType.workoutType()
    ]

    // The quantity types to read from the health store.
    let typesToRead: Set = [
        HKQuantityType.quantityType(forIdentifier: .heartRate)!,
        HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
        HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
        HKQuantityType.quantityType(forIdentifier: .stepCount)!,
        HKQuantityType.workoutType()
    ]
    
    func checkPermissions() {
        healthStore.getRequestStatusForAuthorization(toShare: typesToShare, read: typesToRead) { permissionStatus, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if permissionStatus == .unnecessary {
                isHealthEnabled = true
            }
        }
    }
    
    func requestPermissions() {
        // Request authorization for those quantity types.
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                checkPermissions()
            }
        }
    }
    
    func startWorkout() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .walking
        configuration.locationType = .indoor
        
        do {
            let session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            let builder = session.associatedWorkoutBuilder()
            builder.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore,
                                                         workoutConfiguration: configuration)
            session.startActivity(with: Date())
            builder.beginCollection(withStart: Date()) { (success, error) in
                
                guard success else {
                    // Handle errors.
                    return
                }
                
                // Indicate that the session has started.
            }
        } catch {
            // Handle failure here.
            return
        }
    }
    
    func stopWorkout() {
        
    }
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else {
                return // Nothing to do.
            }
            
            // Calculate statistics for the type.
            let statistics = workoutBuilder.statistics(for: quantityType)
            //let label = labelForQuantityType(quantityType)
            
            DispatchQueue.main.async() {
                // Update the user interface.
            }
        }
    }
    
    var body: some View {
        VStack {
            if isHealthEnabled {
                Button {
                    if isWorkoutActive {
                        
                    } else {
                        
                    }
                } label: {
                    Text(isWorkoutActive ? "Stop" : "Start")
                }
            } else {
                Button {
                    requestPermissions()
                } label: {
                    Text("Enable Health")
                }
            }
        }
        .padding()
        .onAppear() {
            checkPermissions()
        }
    }
}

#Preview {
    ContentView()
}
