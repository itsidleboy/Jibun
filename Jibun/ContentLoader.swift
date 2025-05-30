//
//  ContentLoader.swift
//  Jibun
//
//  Created by Rahul on 30/05/25.
//

import Foundation
import CoreData

// MARK: - JSON Data Models
struct CourseData: Codable {
    let id: String
    let name: String
    let logo: String
    let description: String
    let level: Int
    let isUnlocked: Bool
    let chaptersFile: String
}

struct CoursesContainer: Codable {
    let courses: [CourseData]
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
}

struct CourseContentContainer: Codable {
    let courseId: String
    let chapters: [ChapterData]
}

// MARK: - Content Loader
class ContentLoader {
    static let shared = ContentLoader()
    
    private init() {}
    
    /// Load all courses from courses.json
    func loadCourses() -> [CourseData] {
        guard let url = Bundle.main.url(forResource: "courses", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let container = try? JSONDecoder().decode(CoursesContainer.self, from: data) else {
            print("❌ Failed to load courses.json")
            return []
        }
        
        print("✅ Loaded \(container.courses.count) courses")
        return container.courses
    }
    
    /// Load detailed content for a specific course
    func loadCourseContent(fileName: String) -> CourseContentContainer? {
        let resourceName = fileName.replacingOccurrences(of: ".json", with: "")
        
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let content = try? JSONDecoder().decode(CourseContentContainer.self, from: data) else {
            print("❌ Failed to load \(fileName)")
            return nil
        }
        
        print("✅ Loaded content for course: \(content.courseId)")
        return content
    }
    
    /// Populate Core Data with content from JSON files
    func populateCoreData(context: NSManagedObjectContext) {
        let courses = loadCourses()
        
        for courseData in courses {
            // Create Course entity
            let course = NSEntityDescription.insertNewObject(forEntityName: "Course", into: context)
            course.setValue(UUID(), forKey: "id")
            course.setValue(courseData.name, forKey: "name")
            course.setValue(courseData.logo, forKey: "logo")
            course.setValue(courseData.description, forKey: "desc")
            course.setValue(Int16(courseData.level), forKey: "level")
            
            // Load detailed content for this course
            if let courseContent = loadCourseContent(fileName: courseData.chaptersFile) {
                for chapterData in courseContent.chapters {
                    let chapter = NSEntityDescription.insertNewObject(forEntityName: "Chapter", into: context)
                    chapter.setValue(UUID(), forKey: "id")
                    chapter.setValue(chapterData.name, forKey: "name")
                    chapter.setValue(chapterData.logo, forKey: "logo")
                    chapter.setValue(Int16(chapterData.number), forKey: "number")
                    chapter.setValue(course, forKey: "course")
                    
                    for lessonData in chapterData.lessons {
                        let lesson = NSEntityDescription.insertNewObject(forEntityName: "Lesson", into: context)
                        lesson.setValue(UUID(), forKey: "id")
                        lesson.setValue(lessonData.name, forKey: "name")
                        lesson.setValue(lessonData.logo, forKey: "logo")
                        lesson.setValue(chapter, forKey: "chapter")
                        
                        for slideData in lessonData.slides {
                            let slide = NSEntityDescription.insertNewObject(forEntityName: "Slide", into: context)
                            slide.setValue(UUID(), forKey: "id")
                            slide.setValue(slideData.type, forKey: "type")
                            
                            // Convert slide content to JSON string for storage
                            if let contentData = try? JSONEncoder().encode(slideData.content),
                               let contentString = String(data: contentData, encoding: .utf8) {
                                slide.setValue(contentString, forKey: "content")
                            }
                            
                            slide.setValue(lesson, forKey: "lesson")
                        }
                    }
                }
            }
        }
        
        do {
            try context.save()
            print("✅ Successfully populated Core Data with JSON content")
        } catch {
            print("❌ Failed to save Core Data: \(error)")
        }
    }
}
