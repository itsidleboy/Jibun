//
//  ChapterSectionView.swift
//  Jibun
//
//  Created by Rahul on 30/05/25.
//

import SwiftUI

struct ChapterSectionView: View {
    let chapter: Chapter
    
    var body: some View {
        Section(header: chapterHeader) {
            let sortedLessons = chapter.lessons.sorted { lesson1, lesson2 in
                lesson1.name < lesson2.name
            }
            
            ForEach(sortedLessons, id: \.id) { lesson in
                LessonRowView(lesson: lesson)
            }
        }
    }
    
    private var chapterHeader: some View {
        HStack {
            Text(chapter.logo)
                .font(.title3)
            Text(chapter.name)
                .font(.headline)
            Spacer()
        }
        .padding(.vertical, 2)
    }
}
