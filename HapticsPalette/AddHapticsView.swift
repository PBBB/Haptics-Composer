//
//  AddHapticsView.swift
//  HapticsPalette
//
//  Created by Issac Penn on 3/15/20.
//  Copyright © 2020 Issac Penn. All rights reserved.
//

import SwiftUI
import CoreHaptics

struct AddHapticsView: View {
    
    @Binding var engine: CHHapticEngine!
    @Binding var hapticEvents: [CHHapticEvent]
    
    @State private var hapticEvent: CHHapticEvent!
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            HapticPropertiesView(engine: $engine, hapticEvent: $hapticEvent, actionName: "Add") {
                self.hapticEvents.append(self.hapticEvent)
                self.presentationMode.wrappedValue.dismiss()
            }
                .navigationBarTitle(Text("Add Haptics"), displayMode: .inline)
                .navigationBarItems(leading: Button("Cancel"){
                    self.presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    
}

struct AddHapticsView_Previews: PreviewProvider {
    static var previews: some View {
        let engine = Binding.constant(try? CHHapticEngine())
        let events = Binding.constant([CHHapticEvent]())
        return AddHapticsView(engine: engine, hapticEvents: events)
    }
}

