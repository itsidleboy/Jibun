//
//  LessonRowView.swift
//  Jibun
//
//  Created by Rahul on 30/05/25.
//

import SwiftUI

struct LessonRowView: View {
    let lesson: Lesson
    
    var body: some View {
        NavigationLink(destination: LessonDetailView()) {
            HStack {
                Text(lesson.logo)
                    .font(.body)
                VStack(alignment: .leading, spacing: 2) {
                    Text(lesson.name)
                        .font(.body)
                    Text("\(lesson.slides.count) slides")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding(.vertical, 2)
        }
    }
}
