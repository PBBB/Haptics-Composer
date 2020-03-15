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
            HapticPropertiesView(engine: $engine, hapticEvent: $hapticEvent)
                .navigationBarTitle(Text("Add Haptics"), displayMode: .large)
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

// implementing scroll/touch to dismiss keyboard
class AnyGestureRecognizer: UIGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .began
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       state = .ended
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .cancelled
    }
}

extension SceneDelegate: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
