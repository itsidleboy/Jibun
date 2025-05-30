//
//  CourseSelectionManager.swift
//  Jibun
//
//  Created by Rahul on 30/05/25.
//

import Foundation
import SwiftUI

class CourseSelectionManager: ObservableObject {
    @Published var selectedCourse: Course? = nil
    
    func selectCourse(_ course: Course?) {
        selectedCourse = course
    }
    
    func loadSelectedCourse(from courses: [Course]) {
        if selectedCourse == nil && !courses.isEmpty {
            selectedCourse = courses.first
        }
    }
}
