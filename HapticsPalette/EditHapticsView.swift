//
//  EditHapticsView.swift
//  HapticsPalette
//
//  Created by Issac Penn on 3/16/20.
//  Copyright © 2020 Issac Penn. All rights reserved.
//

import SwiftUI
import CoreHaptics

struct EditHapticsView: View {
    
    @Binding var engine: CHHapticEngine!
    @Binding var hapticEvents: [CHHapticEvent]
    var hapticEvent: CHHapticEvent!
    @State private var tempHapticEvent: CHHapticEvent!
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HapticPropertiesView(engine: $engine, hapticEvent: $tempHapticEvent, actionName: "Save") {
            if let index = self.hapticEvents.firstIndex(of: self.hapticEvent) {
                self.hapticEvents[index] = self.tempHapticEvent
            } else {
                fatalError("No haptic event found")
            }
            
            self.presentationMode.wrappedValue.dismiss()
        }
        .navigationBarTitle(Text("Haptic Details"), displayMode: .inline)
        .onAppear {
            self.tempHapticEvent = self.hapticEvent
        }
    }
}

struct EditHapticsView_Previews: PreviewProvider {
    static var previews: some View {
        let engine = Binding.constant(try? CHHapticEngine())
        let events = Binding.constant([CHHapticEvent]())
//        let event = Binding<CHHapticEvent?>.constant(nil)
        let event: CHHapticEvent? = nil
        return EditHapticsView(engine: engine, hapticEvents: events, hapticEvent: event)
    }
}
