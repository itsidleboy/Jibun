//
//  ContentView.swift
//  Jibun
//
//  Created by Rahul on 29/05/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Chapter.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Chapter.course?.level, ascending: true),
        NSSortDescriptor(keyPath: \Chapter.number, ascending: true)
    ])
    private var chapters: FetchedResults<Chapter>

    var body: some View {
        NavigationStack {
            List {
                ForEach(chapters, id: \.self) { chapter in
                    Section(header: 
                        HStack {
                            Text(chapter.logo ?? "📖")
                                .font(.title3)
                            Text(chapter.name ?? "Unnamed Chapter")
                                .font(.headline)
                            Spacer()
                            if let course = chapter.course {
                                Text(course.logo ?? "")
                                    .font(.caption)
                            }
                        }
                        .padding(.vertical, 2)
                    ) {
                        if let lessons = chapter.lessons as? Set<Lesson> {
                            let sortedLessons = lessons.sorted { lesson1, lesson2 in
                                (lesson1.name ?? "") < (lesson2.name ?? "")
                            }
                            
                            ForEach(sortedLessons, id: \.self) { lesson in
                                NavigationLink(destination: LessonDetailView()) {
                                    HStack {
                                        Text(lesson.logo ?? "📝")
                                            .font(.body)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(lesson.name ?? "Unnamed Lesson")
                                                .font(.body)
                                            if let slides = lesson.slides as? Set<Slide> {
                                                Text("\(slides.count) slides")
                                                    .font(.caption2)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
//                                        Spacer()
//                                        Image(systemName: "chevron.right")
//                                            .font(.caption)
//                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.vertical, 2)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Lessons")
        }
    }
}

#Preview {
    ContentView()
}
