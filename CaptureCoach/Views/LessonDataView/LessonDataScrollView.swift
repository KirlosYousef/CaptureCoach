//
//  LessonDataScrollView.swift
//  CaptureCoach
//
//  Created by Kirlos Yousef on 26/03/2023.
//

import UIKit

class LessonDataScrollView: UIScrollView{
    
    // MARK: - Properties
    private lazy var container: UIView = {
        let view = UIView()
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "Lesson title"
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 24, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "Lesson description"
        label.sizeToFit()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializes
    init(){
        super.init(frame: .zero)
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
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.leftAnchor.constraint(equalTo: leftAnchor),
            container.rightAnchor.constraint(equalTo: rightAnchor),
            container.widthAnchor.constraint(equalTo: widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.leftAnchor.constraint(equalTo: container.leftAnchor,
                                                   constant: 16),
            descriptionLabel.rightAnchor.constraint(equalTo: container.rightAnchor,
                                                    constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor,
                                                     constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                                  constant: 16)
        ])
    }
    
    private func configure(){
        addSubViews()
        updateConstraints()
    }
    
    private func addSubViews(){
        addSubview(container)
    }
}

// MARK: - UI Actions
extension LessonDataScrollView{
    /// Updates the lesson data to the given data
    func updateLessonUI(to lesson: Lesson){
        titleLabel.text = lesson.name
        descriptionLabel.text = lesson.description
    }
}
