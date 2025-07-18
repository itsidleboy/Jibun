//
//  LessonDetailView.swift
//  Jibun
//
//  Created by Rahul on 30/05/25.
//

import SwiftUI

struct LessonDetailView: View {
    @State private var currentChapter: Int = 4
    let totalChapter: Int = 17
    var body: some View {
        ScrollView {
            Button("Complete lesson \(currentChapter)") {
                if currentChapter < totalChapter {
                    currentChapter += 1
                }
            }
            .buttonRepeatBehavior(.enabled)
            .sensoryFeedback(.increase, trigger: currentChapter)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
        .padding()
        .toolbar {
            ToolbarItem(placement: .principal) {
                LessonProgressBar(completed: currentChapter, total: totalChapter)
//                ProgressView(value: Double(currentChapter)/Double(totalChapter), total: Double(totalChapter))
            }
            ToolbarItem(placement: .topBarLeading){
                Button(action: {
                    print("Pressed Back")
                }) {
                    Image(systemName: "gear")
                        .foregroundStyle(.gray)
                }
            }
            ToolbarItem(placement: .topBarTrailing){
                Button(action: {
                    print("Lifes")
                }) {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.red)
                }
            }
            ToolbarItem(placement: .bottomBar) {
                FullWidthButton(title: "Clean Progress") {
                    currentChapter = 0
                }
            }
        }
    }
}

#Preview {
    LessonDetailView()
}
