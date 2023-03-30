//
//  LessonsView.swift
//  CaptureCoach
//
//  Created by Kirlos Yousef on 22/03/2023.
//

import SwiftUI

struct LessonsView: View {
    @ObservedObject var viewModel = LessonsViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.lessons.data.indices,
                 id: \.self) { index in
                NavigationLink(destination: LessonVCWrapper(lessonsVM: viewModel, selectedInd: index)) {
                    LessonCellView(lesson: viewModel.lessons.data[index])
                }
            }
                 .onAppear {
                     self.viewModel.fetchLessons()
                 }
                 .listStyle(.plain)
                 .navigationBarTitle("Lessons")
                 .accessibilityIdentifier("LessonsList")
        }
    }
}

struct LessonsView_Previews: PreviewProvider {
    static var previews: some View {
        LessonsView()
    }
}
