//
//  LessonVCWrapper.swift
//  CaptureCoach
//
//  Created by Kirlos Yousef on 26/03/2023.
//

import SwiftUI

/// View controller representable to represent `LessonVC`.
struct LessonVCWrapper: UIViewControllerRepresentable {
    
    // MARK: - Properties
    /// The ViewModel used to fetch and manage lessons.
    @ObservedObject var lessonsVM: LessonsViewModel
    
    /// The index of the currently selected lesson.
    @State var selectedInd: Int
    
    /// A dictionary tracking the download progress of active downloads.
    @State var activeDownloads: [String: Int] = [:]
    
    // MARK: - Public Methods
    /// Creates a `LessonVC` instance with the currently selected lesson.
    func makeUIViewController(context: Context) -> LessonVC {
        let lessonVC = LessonVC(getLesson())
        lessonVC.delegate = self
        return lessonVC
    }
    
    /// Updates the `LessonVC` instance with the latest lesson data.
    func updateUIViewController(_ uiViewController: LessonVC, context: Context) {
        uiViewController.updateLesson(to: getLesson())
    }
    
    // MARK: - Private Methods
    
    /// Returns a `LessonData` object containing the currently selected lesson and its related data.
    func getLesson() -> LessonData {
        let lessons = lessonsVM.lessons.data
        let selectedLesson = lessons[selectedInd]
        
        let isFirst = (selectedInd == 0)
        let isLast = (selectedInd == lessons.count - 1)
        let donwloadStatus = getDownloadStatus(forURL: selectedLesson.videoUrl)
        
        return LessonData(data: selectedLesson,
                          isLast: isLast,
                          isFirst: isFirst,
                          donwloadStatus: donwloadStatus)
    }
    
    /**
     Returns the download status for the specified video URL.
     
     - Parameter url: The video URL to check.
     - Returns: A `DownloadStatus` indicating the download status for the video.
     */
    func getDownloadStatus(forURL url: String) -> DownloadStatus {
        if activeDownloads[url] != nil {
            return .onProgress(activeDownloads[url] ?? 0)
        }
        else if !(VideoService.shared.localVideoUrl(for: url) == nil){
            return .downloaded
        }
        return .none
    }
    
    /**
     Removes the download link for the specified URL from the `activeDownloads` dictionary.
     
     - Parameter url: The video URL to remove the download link for.
     */
    private func removeDownloadLink(_ url: String) {
        activeDownloads[url] = nil
    }
}

// MARK: - LessonViewController Protocol
extension LessonVCWrapper: LessonVCProtocol {
    
    /// Decrements the `selectedInd` property to move to the previous lesson.
    func didTapPreviousLesson() {
        selectedInd -= 1
    }
    
    /// Increments the `selectedInd` property to move to the next lesson.
    func didTapNextLesson() {
        selectedInd += 1
    }
    
    /**
     Plays the video for the currently selected lesson using `VideoService`.
     
     - Parameter vc: The view controller from which to present the video player.
     */
    func didTapPlayVideo(in vc: UIViewController) {
        VideoService.shared.playVideo(from: getLesson().data.videoUrl, in: vc)
    }
    
    /// Handles user tapping the download button by starting or cancelling the download depending on the current download status.
    func didTapDownload() {
        let lesson = getLesson()
        let videoUrl = lesson.data.videoUrl
        let donwloadStatus = getDownloadStatus(forURL: videoUrl)
        
        switch donwloadStatus {
        case .onProgress(_): // If already in progress, cancel it
            VideoService.shared.cancelDownload(for: videoUrl)
        case .none:
            VideoService.shared.downloadVideo(from: videoUrl,
                                              progressHandler: { progress in
                
                if progress == -1 { // Cancelled
                    removeDownloadLink(videoUrl)
                } else {
                    activeDownloads[videoUrl] = progress
                }
            }){
                removeDownloadLink(videoUrl)
            }
        default:
            break
        }
    }
    
    /// Cancels all the running downloads.
    func cancelAllDownloads(){
        VideoService.shared.cancelAllDownloads()
    }
}
