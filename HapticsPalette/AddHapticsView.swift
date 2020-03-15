//
//  AddHapticsView.swift
//  HapticsPalette
//
//  Created by Issac Penn on 3/15/20.
//  Copyright © 2020 Issac Penn. All rights reserved.
//

import SwiftUI

struct AddHapticsView: View {
    let types = ["Transient", "Continuous", "Pause"]
    let notes = ["Transient":"Transient desc", "Continious":"Continius desc", "Pause":"Pause desc"]
    @State private var selection = "Transient"
    @State private var relativeTime = "0"
    @State private var duration = "0.5"
    @State private var intensity = 0.5
    @State private var sharpness = 0.5
    @State private var attackTime = 0.0
    @State private var decayTime = 0.0
    @State private var sustained = false
    @State private var releaseTime = 0.0
    @State private var continuousPreview = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
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
                            Slider(value: $intensity, in: 0.0...1.0)
                            Text("\(intensity, specifier:"%.02f")")
                        }
                        HStack {
                            Text("Sharpness")
                            Slider(value: $sharpness, in: 0.0...1.0)
                            Text("\(sharpness, specifier:"%.02f")")
                        }
                        HStack {
                            Text("Relative Time (seconds)")
                                .layoutPriority(1)
                                .padding(.trailing, 8)
                            TextField("", text: $relativeTime)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("Duration (seconds)")
                                .layoutPriority(1)
                                .padding(.trailing, 8)
                            TextField("", text: $duration)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    
                    Section (header: Text("ENVELOPE PARAMETERS")) {
                        HStack {
                            Text("Attack Time")
                            Slider(value: $attackTime, in: -1.0...1.0)
                            Text("\(attackTime, specifier:"%.02f")")
                        }
                        HStack {
                            Text("Decay Time")
                            Slider(value: $decayTime, in: -1.0...1.0)
                            Text("\(decayTime, specifier:"%.02f")")
                        }
                        HStack {
                            Toggle("Sustained", isOn: $sustained)
                        }
                        HStack {
                            Text("Release Time")
                            Slider(value: $releaseTime, in: -1.0...1.0)
                            Text("\(releaseTime, specifier:"%.02f")")
                        }
                    }
                    
                    Section (header: Text("PREVIEW"), footer: Text("Automatically plays haptic preview each time you change a parameter.")) {
                        Toggle("Continuous Preview", isOn: $continuousPreview)
                    }
                    
                }
                
                HStack {
                    Button("Preview") {
                        
                    }
                    Spacer()
                    Button("Add") {
                        
                    }
                    .font(Font.body.weight(.medium))
                }
                .padding(.horizontal)
                
                
            }
            .navigationBarTitle(Text("Add Haptics"), displayMode: .large)
            .navigationBarItems(leading: Button("Cancel"){
                self.presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct AddHapticsView_Previews: PreviewProvider {
    static var previews: some View {
        AddHapticsView()
    }
}
