//
//  TextField+Styles.swift
//  StayFocused
//
//  Created by Maksym Horobets on 10.09.2025.
//

import SwiftUI

struct GlassyTextFieldStyle: TextFieldStyle {
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.thinMaterial)
            }
    }
    
}

extension TextFieldStyle where Self == GlassyTextFieldStyle {
    static var glassy: GlassyTextFieldStyle { GlassyTextFieldStyle() }
}
