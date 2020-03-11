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
    var body: some View {
        NavigationView {
            if supportsHaptics {
                VStack {
                    List {
                        Text("1")
                        Text("2")
                    }
                    HStack {
                        Button("Play") {
                            
                        }
                        Spacer()
                        Button("Add Haptics") {
                            
                        }
                    }
                    .padding(.horizontal, 16.0)
                }
                .navigationBarTitle("Haptics Palette")
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
                }
                .navigationBarTitle("Haptics Palette")
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
                    fatalError("Engine Creation Error: \(error)")
                }
            }
            self.engine.resetHandler = self.engineResetHandler
            self.engine.stoppedHandler = self.engineStoppedHandler(reason:)
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
               fatalError("Failed to restart the engine: \(error)")
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
