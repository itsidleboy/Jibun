//
//  FullWidthButton.swift
//  Jibun
//
//  Created by Rahul on 30/05/25.
//

import SwiftUI

struct FullWidthButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    FullWidthButton(title: "Test") {
        print("pressed")
    }
}

