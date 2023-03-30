//
//  ProgressBarView.swift
//  CaptureCoach
//
//  Created by Kirlos Yousef on 30/03/2023.
//

import UIKit
import SwiftProgressView

class ProgressBarView: UIView {
    
    // MARK: - Properties
    private lazy var progressView: ProgressPieView = {
        let progressBar = ProgressPieView()
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        return progressBar
    }()
    
    private lazy var cancelLabel: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "Cancel download"
        label.text = "Cancel Download"
        label.textColor = .tintColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var progress: CGFloat = 0 {
        didSet {
            updateProgressView()
        }
    }
    
    private var progressWidthConstraint: NSLayoutConstraint?
    
    // MARK: - Initializes
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - UI Configration
    override func updateConstraints() {
        super.updateConstraints()
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: topAnchor),
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressView.widthAnchor.constraint(equalTo: progressView.heightAnchor),
            progressView.trailingAnchor.constraint(equalTo: cancelLabel.leadingAnchor,
                                                   constant: -4)
        ])
        
        NSLayoutConstraint.activate([
            cancelLabel.topAnchor.constraint(equalTo: topAnchor),
            cancelLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            cancelLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configure() {
        addSubview(cancelLabel)
        addSubview(progressView)
    }
    
    private func updateProgressView() {
        progressView.setProgress(progress, animated: true)
        setNeedsLayout()
    }
}

// MARK: - UI Actions
extension ProgressBarView {
    /// Updates the progress of the progress bar view
    func updateProgress(_ value: Int) {
        progress = CGFloat(value) / 100
    }
}
