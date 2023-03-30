//
//  VideoThumbnailView.swift
//  CaptureCoach
//
//  Created by Kirlos Yousef on 26/03/2023.
//

import UIKit

class VideoThumbnailView: UIView{
    
    // MARK: - Properties
    private lazy var playIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "play.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0.7
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initializes
    init(){
        super.init(frame: .zero)
        self.accessibilityIdentifier = "VideoThumbnailView"
        self.translatesAutoresizingMaskIntoConstraints = false
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Configration
    override func updateConstraints() {
        super.updateConstraints()
        
        NSLayoutConstraint.activate([
            playIconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            playIconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            playIconImageView.widthAnchor.constraint(equalToConstant: 48),
            playIconImageView.heightAnchor.constraint(equalTo: playIconImageView.widthAnchor),
        ])
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: topAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            thumbnailImageView.leftAnchor.constraint(equalTo: leftAnchor),
            thumbnailImageView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    private func configure(){
        addSubviews()
        updateConstraints()
    }
    
    private func addSubviews(){
        addSubview(thumbnailImageView)
        addSubview(playIconImageView)
    }
}

// MARK: - UI Actions
extension VideoThumbnailView{
    /// Updates the thumbnail image to the given url
    func updateThumbnail(url thumbnailURL: String){
        ImageService.downloadImage(from: thumbnailURL) { image in
            self.thumbnailImageView.image = image
        }
    }
}
