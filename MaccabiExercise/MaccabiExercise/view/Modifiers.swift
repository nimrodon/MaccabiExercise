//
//  Modifiers.swift
//  MaccabiExercise
//
//  Created by Nimrod Yizhar on 07/05/2024.
//

import Foundation
import SwiftUI

struct cardFrameModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1))
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            .padding(.horizontal, 20)
    }
}


extension View {
    
    func cardFrame() -> some View {
        self.modifier(cardFrameModifier())
    }
}
