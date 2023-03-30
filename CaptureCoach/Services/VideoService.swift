//
//  VideoService.swift
//  CaptureCoach
//
//  Created by Kirlos Yousef on 27/03/2023.
//

import Foundation
import AVKit

/**
 This class provides functions to download and play videos from URLs.
 */
class VideoService: NSObject{
    
    // MARK: - Properties
    static var shared = VideoService()
    
    /// The completion handlers for video downloads.
    private var completionHandlers: [String: () -> Void] = [:]
    
    /// The completion handlers for video downloads progress
    private var progressHandlers: [String: (Int) -> Void] = [:]
    
    /// The download task for the current video download.
    private var downloadTasks: [URLSessionDownloadTask] = []
    
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
        return session
    }()
    
    // MARK: - Public Methods
    /**
     Downloads a video from a given URL.
     
     - Parameters:
     - url: The URL of the video to download.
     - progressHandler: A closure to be called when the progress is updated.
     - completion: A closure to be called when the download is complete.
     */
    func downloadVideo(from url: String,
                       progressHandler: @escaping (Int) -> Void,
                       completion: @escaping () -> Void){
        guard let videoUrl = URL(string: url) else {
            completion()
            return
        }
        
        // Create a download task and start it.
        let downloadTask = session.downloadTask(with: videoUrl)
        downloadTask.resume()
        downloadTask.taskDescription = url
        downloadTasks.append(downloadTask)
        
        // Save the completion handler to call later.
        completionHandlers[url] = completion
        progressHandlers[url] = progressHandler
    }
    
    /// Cancels the video download of the provided URL, if there is one.
    func cancelDownload(for url: String) {
        if let downloadTask = downloadTasks.first(where: { $0.currentRequest?.url?.absoluteString == url }) {
            downloadTask.cancel()
            downloadTasks.removeAll(where: { $0 == downloadTask })
            completionHandlers[url]?()
            completionHandlers[url] = nil
            progressHandlers[url]?(-1)
            progressHandlers[url] = nil
        }
    }
    
    /// Cancels all video downloads.
    func cancelAllDownloads() {
        for downloadTask in downloadTasks {
            downloadTask.cancel()
        }
        downloadTasks.removeAll()
        completionHandlers = [:]
    }
    
    func playVideo(from urlString: String, in vc: UIViewController) {
        guard let videoUrl = URL(string: urlString) else {
            return
        }
        
        var url = videoUrl
        
        // If the video is already downloaded, play it from the local file.
        // Otherwise, play it from the remote URL.
        if let localUrl = localVideoUrl(for: urlString) {
            url = localUrl
        }
        
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        vc.present(playerViewController, animated: true)
        player.play()
    }
    
    /**
     Gets the URL of the local video file, if it exists
     
     - Parameters:
     - url: The URL of the video to check.
     
     - Returns: The URL of the local video file, or nil if it does not exist.
     */
    func localVideoUrl(for url: String) -> URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let videoUrl = URL(string: url)!
        let destinationUrl = documentsDirectory.appendingPathComponent(videoUrl.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            return destinationUrl
        } else {
            return nil
        }
    }
}

extension VideoService: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let urlString = downloadTask.taskDescription,
              let completion = completionHandlers[urlString],
              let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        let videoUrl = URL(string: urlString)!
        let destinationUrl = documentsDirectory.appendingPathComponent(videoUrl.lastPathComponent)
        
        do {
            try FileManager.default.moveItem(at: location, to: destinationUrl)
            completion()
        } catch {
            completion()
        }
        
        // Clean up the download task.
        self.downloadTasks.removeAll(where: { $0.taskDescription == urlString })
        self.progressHandlers[urlString]?(-1)
        self.progressHandlers[urlString] = nil
        self.completionHandlers[urlString]?()
        self.completionHandlers[urlString] = nil
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let urlString = downloadTask.taskDescription else {
            return
        }
        
        let progress = Int((Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)) * 100.0)
        
        // Dispatch the progress handlers for this URL.
        DispatchQueue.main.async {
            self.progressHandlers[urlString]?(progress)
        }
    }
}
