//
//  LessonCellView.swift
//  CaptureCoach
//
//  Created by Kirlos Yousef on 22/03/2023.
//

import SwiftUI

struct LessonCellView: View {
    
    private let lesson: Lesson
    @State private var image: UIImage?
    
    init(lesson: Lesson) {
        self.lesson = lesson
    }
    
    var body: some View {
        HStack {
            Image(uiImage: image ?? UIImage(systemName: "arrow.triangle.2.circlepath.circle")!)
                .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 56)
            .accessibilityIdentifier("LessonImage")
            
            Text(lesson.name)
                .font(.subheadline)
                .padding(.leading, 8)
                .accessibilityIdentifier("LessonName")
        }.onAppear {
            // Call the `downloadImage` function when the view appears
            ImageService.downloadImage(from: lesson.thumbnail) { downloadedImage in
                // Store the downloaded image in the `image` state variable
                self.image = downloadedImage
            }
        }
    }
}


struct LessonView_Previews: PreviewProvider {
    static var previews: some View {
        LessonCellView(lesson: Lesson(
            id: 950,
            name: "The Key To Success In iPhone Photography",
            description: "Testing",
            thumbnail: "https://embed-ssl.wistia.com/deliveries/b57817b5b05c3e3129b7071eee83ecb7.jpg?image_crop_resized=1000x560",
            videoUrl: "test")
        )
    }
}
