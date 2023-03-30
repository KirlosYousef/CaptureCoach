//
//  DownloadButton.swift
//  CaptureCoach
//
//  Created by Kirlos Yousef on 28/03/2023.
//

import UIKit

protocol DownloadButtonDelegate: AnyObject {
    func didTapDownloadButton()
    func didUpdateDownloadButton()
}

class DownloadButton: UIButton {
    
    // MARK: - Properties
    private lazy var progressBarView: ProgressBarView = {
        let view = ProgressBarView()
        
        let didTapOn = UITapGestureRecognizer(target: self, action: #selector(didTapDownload))
        view.addGestureRecognizer(didTapOn)
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private var downloadStatus: DownloadStatus = .none {
        didSet {
            switch downloadStatus {
            case .none:
                accessibilityIdentifier = "Download lesson"
                configuration?.title = "Download"
                configuration?.image = UIImage(systemName: "icloud.and.arrow.down")
                progressBarView.removeFromSuperview() // Remove progress bar from button
            case .downloaded:
                configuration?.title = ""
                configuration?.image = nil
                progressBarView.removeFromSuperview()  // Remove progress bar from button
            case .onProgress:
                configuration?.title = ""
                configuration?.image = nil
                addProgressView()
            }
            
            self.delegate?.didUpdateDownloadButton()
        }
    }
    
    weak var delegate: DownloadButtonDelegate?
    
    // MARK: - Initializes
    init() {
        super.init(frame: .zero)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Configration
    private func configure(){
        var config = UIButton.Configuration.plain()
        config.imagePlacement = .leading
        config.imagePadding = 4
        self.configuration = config
        
        self.addTarget(self, action: #selector(didTapDownload), for: .touchUpInside)
    }
    
    /// Add progress bar to the button
    private func addProgressView(){
        addSubview(progressBarView)
        
        NSLayoutConstraint.activate([
            progressBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressBarView.topAnchor.constraint(equalTo: topAnchor),
            progressBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressBarView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - UI Actions
extension DownloadButton {
    /// Updates the stauts of the download button
    func updateStatus(to downloadStatus: DownloadStatus){
        self.downloadStatus = downloadStatus
        
        if case .onProgress(let progress) = downloadStatus {
            progressBarView.updateProgress(progress)
        }
    }
    
    @objc
    private func didTapDownload() {
        self.delegate?.didTapDownloadButton()
    }
}
