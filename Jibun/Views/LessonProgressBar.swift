//
//  LessonProgressBar.swift
//  Jibun
//
//  Created by Rahul on 30/05/25.
//

import SwiftUI

struct LessonProgressBar: View {
    let completed: Int
    let total: Int

    private var progress: CGFloat {
        guard total > 0 else { return 0 }
        return CGFloat(completed) / CGFloat(total)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .frame(height: 10)
                        .foregroundColor(Color(UIColor.secondarySystemBackground))

                    RoundedRectangle(cornerRadius: 6)
                        .frame(width: geometry.size.width * progress, height: 7)
                        .foregroundColor(Color.accentColor)
                        .animation(.easeInOut(duration: 0.2), value: progress)
                }
            }
            .frame(height: 10)
        }
    }
}

#Preview {
    LessonProgressBar(completed: 12, total: 17)
}
