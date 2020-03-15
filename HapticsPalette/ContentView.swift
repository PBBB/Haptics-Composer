//
//  ContentView.swift
//  HapticsPalette
//
//  Created by Issac Penn on 3/11/20.
//  Copyright © 2020 Issac Penn. All rights reserved.
//

import SwiftUI
import CoreHaptics

struct ContentView: View {
    @State private var supportsHaptics: Bool = true
    @State private var engine: CHHapticEngine!
    @State private var hapticEvents: [CHHapticEvent] = []
    @State private var showAddSheet = false
    
    var body: some View {
        NavigationView {
            if supportsHaptics {
                VStack {
                    
                    List {
                        ForEach(hapticEvents, id: \.self) { event in
                            NavigationLink(destination: AddHapticsView(engine: self.$engine, hapticEvents: self.$hapticEvents)) {
                                Text("\(event.type.rawValue)")
                            }
                        }
                        .onDelete { indexSet in
                            self.hapticEvents.remove(atOffsets: indexSet)
                        }
                    }
                    
                    HStack {
                        Button("Add Haptics") {
                            self.showAddSheet = true
                        }
                        Spacer()
                        Button("Play") {
                            self.playHaptics()
                            
                        }
                        .disabled(self.hapticEvents.count == 0)
                        Spacer()
                        Button("Share") {
                            
                        }
                        .disabled(self.hapticEvents.count == 0)
                    }
                    .padding(.horizontal, 16.0)
                }
                .navigationBarTitle("Haptics Composer")
            .navigationBarItems(leading: EditButton())
//                .navigationBarItems(
//                    leading: Button("Play") {
//
//                    }, trailing: Button("Add Haptics") {
//
//                    })
            } else {
                VStack(spacing: 4) {
                    Text("Your devices doesn't support Core Haptics.")
                    Text("Please update your phone to iPhone 8 or later.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .navigationBarTitle("Haptics Composer")
                }
            }
        }
        .onAppear {
            let hapticCapability = CHHapticEngine.capabilitiesForHardware()
//            self.supportsHaptics = hapticCapability.supportsHaptics
            if self.supportsHaptics {
                // Create and configure a haptic engine.
                do {
                    self.engine = try CHHapticEngine()
                } catch let error {
                    print("Engine Creation Error: \(error)")
                }
            }
            //for preview
            if self.engine == nil { return }
            
            self.engine.resetHandler = self.engineResetHandler
            self.engine.stoppedHandler = self.engineStoppedHandler(reason:)
            self.engine.start(completionHandler: nil)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            //for preview
            if self.engine == nil { return }
            self.engine.start(completionHandler: nil)
        }
        .sheet(isPresented: self.$showAddSheet, content: { AddHapticsView(engine: self.$engine, hapticEvents: self.$hapticEvents) })
        
        
    }
    
    func playHaptics() {
        do {
            let pattern = try CHHapticPattern(events: self.hapticEvents, parameterCurves: [])
            let player = try engine.makeAdvancedPlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
            
        } catch {
            print("Failed to create palyer: \(error)")
        }
        
    }
    
    func engineResetHandler() {
        print("Reset Handler: Restarting the engine.")
           
           do {
               // Try restarting the engine.
               try self.engine.start()
                       
               // Register any custom resources you had registered, using registerAudioResource.
               // Recreate all haptic pattern players you had created, using createPlayer.

           } catch {
               print("Failed to restart the engine: \(error)")
           }
    }
    
    func engineStoppedHandler(reason: CHHapticEngine.StoppedReason) {
        print("Stop Handler: The engine stopped for reason: \(reason.rawValue)")
        switch reason {
        case .audioSessionInterrupt: print("Audio session interrupt")
        case .applicationSuspended: print("Application suspended")
        case .idleTimeout: print("Idle timeout")
        case .systemError: print("System error")
        case .notifyWhenFinished:
            print("Notify when finished")
        @unknown default:
            print("Unknown error")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
