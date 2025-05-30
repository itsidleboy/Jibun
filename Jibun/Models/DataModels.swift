//
//  DataModels.swift
//  Jibun
//
//  Created by Rahul on 30/05/25.
//

import Foundation

// MARK: - Core Data Models
struct Course: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let logo: String
    let description: String
    let level: Int
    let isUnlocked: Bool
    let chaptersFile: String
    var chapters: [Chapter] = []
    
    static func == (lhs: Course, rhs: Course) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Chapter: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let logo: String
    let number: Int
    let description: String
    var lessons: [Lesson] = []
    
    static func == (lhs: Chapter, rhs: Chapter) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Lesson: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let logo: String
    var slides: [Slide] = []
    
    static func == (lhs: Lesson, rhs: Lesson) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Slide: Codable, Identifiable, Hashable {
    let id: String
    let type: String
    let content: SlideContent
    let skippable: Bool
    
    static func == (lhs: Slide, rhs: Slide) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct SlideContent: Codable {
    // Introduction slides
    let title: String?
    let text: String?
    let image: String?
    
    // Character display slides
    let character: String?
    let pronunciation: String?
    let example: String?
    let strokeOrder: String?
    
    // Phrase display slides
    let japanese: String?
    let hiragana: String?
    let english: String?
    let usage: String?
    
    // Vocabulary display slides
    let word: String?
    let kanji: String?
    
    // Quiz slides
    let question: String?
    let options: [String]?
    let correctAnswer: Int?
    let explanation: String?
    
    // Character intro slides
    let romaji: String?
    let audio: String?
    let description: String?
}

// MARK: - User Progress Model
struct UserProgress: Codable {
    let id: String
    let lessonId: String
    let completedSlideIds: [String]
    let lastUpdated: Date
    
    init(id: String = UUID().uuidString, lessonId: String, completedSlideIds: [String] = [], lastUpdated: Date = Date()) {
        self.id = id
        self.lessonId = lessonId
        self.completedSlideIds = completedSlideIds
        self.lastUpdated = lastUpdated
    }
}

// MARK: - JSON Container Models (for file loading)
struct CoursesContainer: Codable {
    let courses: [CourseData]
}

struct CourseData: Codable {
    let id: String
    let name: String
    let logo: String
    let description: String
    let level: Int
    let isUnlocked: Bool
    let chaptersFile: String
}

struct CourseContentContainer: Codable {
    let courseId: String
    let chapters: [ChapterData]
}

struct ChapterData: Codable {
    let id: String
    let name: String
    let logo: String
    let number: Int
    let description: String
    let lessons: [LessonData]
}

struct LessonData: Codable {
    let id: String
    let name: String
    let logo: String
    let slides: [SlideData]
}

struct SlideData: Codable {
    let id: String
    let type: String
    let content: SlideContent
    let skippable: Bool
}
