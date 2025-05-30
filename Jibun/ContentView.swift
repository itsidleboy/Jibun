//
//  ContentView.swift
//  Jibun
//
//  Created by Rahul on 29/05/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var dataManager: DataManager
    @StateObject private var courseManager = CourseSelectionManager()
    
    // Computed property to filter chapters based on selected course
    private var filteredChapters: [Chapter] {
        if let selectedCourse = courseManager.selectedCourse {
            return selectedCourse.chapters
        } else {
            // Return all chapters from all courses
            return dataManager.courses.flatMap { $0.chapters }
        }
    }
    
    var body: some View {
        NavigationStack {
            // Chapters and Lessons List
            List {
                ForEach(filteredChapters, id: \.id) { chapter in
                    ChapterSectionView(chapter: chapter)
                }
            }
            .listStyle(InsetGroupedListStyle())
//            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        // Individual courses
                        ForEach(dataManager.courses, id: \.id) { course in
                            Button(course.name) {
                                courseManager.selectCourse(course)
                            }
                            // Disable if course isUnlocked is false
                        }
                    } label: {
                        HStack {
                            Text(courseManager.selectedCourse?.name ?? "All Courses")
                                .font(.headline)
                                .lineLimit(1)
                            Image(systemName: "chevron.down")
                                .font(.caption)
                        }
                        .foregroundColor(.primary)
                    }
                }
            }
        }
        .onAppear {
            courseManager.loadSelectedCourse(from: dataManager.courses)
        }
    }
}


#Preview {
    ContentView()
}
