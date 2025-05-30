//
//  DataManager.swift
//  Jibun
//
//  Created by Rahul on 30/05/25.
//

import Foundation

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var courses: [Course] = []
    @Published var userProgress: [UserProgress] = []
    
    private let userProgressKey = "user_progress"
    
    private init() {
        loadData()
        loadUserProgress()
    }
    
    // MARK: - Data Loading
    func loadData() {
        courses = loadAllCourses()
    }
    
    private func loadAllCourses() -> [Course] {
        let courseDataList = loadCoursesFromJSON()
        var loadedCourses: [Course] = []
        
        for courseData in courseDataList {
            if let courseContent = loadCourseContent(fileName: courseData.chaptersFile) {
                let chapters = courseContent.chapters.map { chapterData in
                    let lessons = chapterData.lessons.map { lessonData in
                        let slides = lessonData.slides.map { slideData in
                            Slide(
                                id: slideData.id,
                                type: slideData.type,
                                content: slideData.content,
                                skippable: slideData.skippable
                            )
                        }
                        return Lesson(
                            id: lessonData.id,
                            name: lessonData.name,
                            logo: lessonData.logo,
                            slides: slides
                        )
                    }
                    return Chapter(
                        id: chapterData.id,
                        name: chapterData.name,
                        logo: chapterData.logo,
                        number: chapterData.number,
                        description: chapterData.description,
                        lessons: lessons
                    )
                }
                
                let course = Course(
                    id: courseData.id,
                    name: courseData.name,
                    logo: courseData.logo,
                    description: courseData.description,
                    level: courseData.level,
                    isUnlocked: courseData.isUnlocked,
                    chaptersFile: courseData.chaptersFile,
                    chapters: chapters
                )
                loadedCourses.append(course)
            }
        }
        
        return loadedCourses.sorted { $0.level < $1.level }
    }
    
    private func loadCoursesFromJSON() -> [CourseData] {
        guard let url = Bundle.main.url(forResource: "courses", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let container = try? JSONDecoder().decode(CoursesContainer.self, from: data) else {
            print("❌ Failed to load courses.json")
            return []
        }
        
        print("✅ Loaded \(container.courses.count) courses from JSON")
        return container.courses
    }
    
    private func loadCourseContent(fileName: String) -> CourseContentContainer? {
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
    
    // MARK: - User Progress Management
    private func loadUserProgress() {
        if let data = UserDefaults.standard.data(forKey: userProgressKey),
           let progress = try? JSONDecoder().decode([UserProgress].self, from: data) {
            userProgress = progress
        }
    }
    
    private func saveUserProgress() {
        if let data = try? JSONEncoder().encode(userProgress) {
            UserDefaults.standard.set(data, forKey: userProgressKey)
        }
    }
    
    func updateUserProgress(for lessonId: String, completedSlideIds: [String]) {
        if let index = userProgress.firstIndex(where: { $0.lessonId == lessonId }) {
            userProgress[index] = UserProgress(
                id: userProgress[index].id,
                lessonId: lessonId,
                completedSlideIds: completedSlideIds,
                lastUpdated: Date()
            )
        } else {
            let newProgress = UserProgress(
                lessonId: lessonId,
                completedSlideIds: completedSlideIds
            )
            userProgress.append(newProgress)
        }
        saveUserProgress()
    }
    
    func getUserProgress(for lessonId: String) -> UserProgress? {
        return userProgress.first { $0.lessonId == lessonId }
    }
    
    // MARK: - Data Access Helpers
    func getCourse(by id: String) -> Course? {
        return courses.first { $0.id == id }
    }
    
    func getChapter(courseId: String, chapterId: String) -> Chapter? {
        return getCourse(by: courseId)?.chapters.first { $0.id == chapterId }
    }
    
    func getLesson(courseId: String, chapterId: String, lessonId: String) -> Lesson? {
        return getChapter(courseId: courseId, chapterId: chapterId)?.lessons.first { $0.id == lessonId }
    }
    
    func getAllChapters() -> [Chapter] {
        return courses.flatMap { $0.chapters }
    }
    
    func getChapters(for course: Course) -> [Chapter] {
        return course.chapters.sorted { $0.number < $1.number }
    }
}
