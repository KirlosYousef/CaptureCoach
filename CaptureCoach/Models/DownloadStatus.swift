//
//  DownloadStatus.swift
//  CaptureCoach
//
//  Created by Kirlos Yousef on 28/03/2023.
//

import Foundation

enum DownloadStatus: Equatable{
    case downloaded
    case onProgress(Int)
    case none
}
