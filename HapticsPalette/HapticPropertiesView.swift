//
//  HapticPropertiesView.swift
//  HapticsPalette
//
//  Created by Issac Penn on 3/15/20.
//  Copyright © 2020 Issac Penn. All rights reserved.
//

import SwiftUI
import CoreHaptics

struct HapticPropertiesView: View {
    private let types = ["Transient", "Continuous"]
    @Binding var engine: CHHapticEngine!
    @Binding var hapticEvent: CHHapticEvent!
    let actionName: String
    let actionHandler: () -> Void
    
    @State private var selection = "Transient"
    @State private var relativeTime = "0"
    @State private var duration = "0.5"
    @State private var intensity = 0.5
    @State private var sharpness = 0.5
    @State private var attackTime = 0.0
    @State private var decayTime = 0.0
    @State private var sustained = true
    @State private var releaseTime = 0.0
    @State private var continuousPreview = false
    
    var body: some View {
        VStack {
            Form {
                Section {
                    Picker("Type", selection: $selection) {
                        ForEach(types, id: \.self) { type in
                            Text(type)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(SegmentedPickerStyle())
                    
                    HStack {
                        Text("Intensity")
                        Slider(value: $intensity, in: 0.0...1.0, onEditingChanged: self.continuousPreview)
                        Text("\(intensity, specifier:"%.02f")")
                    }
                    HStack {
                        Text("Sharpness")
                        Slider(value: $sharpness, in: 0.0...1.0, onEditingChanged: self.continuousPreview)
                        Text("\(sharpness, specifier:"%.02f")")
                    }
                    HStack {
                        Text("Relative Time (seconds)")
                            .layoutPriority(1)
                            .padding(.trailing, 8)
                        TextField("", text: $relativeTime, onCommit: { self.continuousPreview() })
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Duration (seconds)")
                            .layoutPriority(1)
                            .padding(.trailing, 8)
                        TextField("", text: $duration, onCommit: { self.continuousPreview() })
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                //if self.selection == "Continuous" {
                if true {
                    Section (header: Text("ENVELOPE PARAMETERS")) {
                        HStack {
                            Text("Attack Time")
                            Slider(value: $attackTime, in: -1.0...1.0, onEditingChanged: self.continuousPreview)
                            Text("\(attackTime, specifier:"%.02f")")
                        }
                        HStack {
                            Text("Decay Time")
                            Slider(value: $decayTime, in: -1.0...1.0, onEditingChanged: self.continuousPreview)
                            Text("\(decayTime, specifier:"%.02f")")
                        }
                        HStack {
                            Toggle("Sustained", isOn: $sustained)
                        }
                        HStack {
                            Text("Release Time")
                            Slider(value: $releaseTime, in: 0...1.0, onEditingChanged: self.continuousPreview)
                            Text("\(releaseTime, specifier:"%.02f")")
                        }
                    }
                    .transition(.opacity)
                }
                
                Section (header: Text("PREVIEW"), footer: Text("Automatically plays haptic preview each time you change a parameter (except \"Sustained\" toggle).")) {
                    Toggle("Real-time Preview", isOn: $continuousPreview)
                }
            }
            
            HStack {
                Button("Preview") {
                    self.previewHaptics()
                }
                Spacer()
                Button(actionName) {
                    self.createHapticEvent()
                    //                        self.hapticEvents.append(self.hapticEvent)
                    self.actionHandler()
//                    self.presentationMode.wrappedValue.dismiss()
                }
                .font(Font.body.weight(.medium))
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
    
    func createHapticEvent() {
        let eventType: CHHapticEvent.EventType
        switch selection {
        case "Transient":
            eventType = .hapticTransient
        case "Continuous":
            eventType = .hapticContinuous
        default:
            eventType = .hapticTransient
        }
        
        let parameters = [CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(self.intensity)),
                          CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(self.sharpness)),
                          CHHapticEventParameter(parameterID: .attackTime, value: Float(self.attackTime)),
                          CHHapticEventParameter(parameterID: .decayTime, value: Float(self.decayTime)),
                          CHHapticEventParameter(parameterID: .sustained, value: Float(self.sustained ? 1.0 : 0.0)),
                          CHHapticEventParameter(parameterID: .releaseTime, value: Float(self.releaseTime))
        ]
        
        let relativeTime = Double(self.relativeTime) ?? 0.0
        let duration = Double(self.duration) ?? 1.0
        
        let hapticEvent = CHHapticEvent(eventType: eventType, parameters: parameters, relativeTime: relativeTime, duration: duration)
        self.hapticEvent = hapticEvent
    }
    
    func previewHaptics() {
        self.createHapticEvent()
        do {
            let pattern = try CHHapticPattern(events: [self.hapticEvent], parameters: [])
            let player = try engine.makeAdvancedPlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            print("Failed to create palyer: \(error)")
        }
    }
    
    func continuousPreview(isStartingChanging: Bool = false) {
        if self.continuousPreview && !isStartingChanging {
            self.previewHaptics()
        }
    }
}

struct HapticPropertiesView_Previews: PreviewProvider {
    static var previews: some View {
        let engine = Binding.constant(try? CHHapticEngine())
        let event = Binding<CHHapticEvent?>.constant(nil)
        return HapticPropertiesView(engine: engine, hapticEvent: event, actionName: "Add") {
            
        }
    }
}
