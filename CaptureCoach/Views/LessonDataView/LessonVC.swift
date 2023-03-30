//
//  LessonViewController.swift
//  CaptureCoach
//
//  Created by Kirlos Yousef on 26/03/2023.
//

import UIKit

protocol LessonVCProtocol{
    func didTapPreviousLesson()
    func didTapNextLesson()
    func didTapDownload()
    func didTapPlayVideo(in vc: UIViewController)
    func cancelAllDownloads()
}

class LessonVC: UIViewController{
    
    // MARK: - Properties
    var delegate: LessonVCProtocol?
    private var lesson: LessonData
    
    private lazy var dataScrollView = LessonDataScrollView()
    
    private lazy var downloadLessonBtn = DownloadButton()
    
    private lazy var videoThumbnail: VideoThumbnailView = {
        let view = VideoThumbnailView()
        
        let didTapOn = UITapGestureRecognizer(target: self, action: #selector(playVideo))
        view.addGestureRecognizer(didTapOn)
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private lazy var previousLessonBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Previous lesson", for: .normal)
        button.setTitleColor(.tintColor, for: .normal)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        
        button.addTarget(self, action: #selector(didTapPreviousLesson), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nextLessonBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Next lesson", for: .normal)
        button.setTitleColor(.tintColor, for: .normal)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        
        button.addTarget(self, action: #selector(didTapNextLesson), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializes
    init(_ lesson: LessonData){
        self.lesson = lesson
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - VC Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadLessonBtn.delegate = self
        
        addSubViews()
        updateLessonUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SetNavBarDownloadBtn()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.cancelAllDownloads()
    }
    
    // MARK: - UI Configration
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        NSLayoutConstraint.activate([
            videoThumbnail.topAnchor.constraint(equalTo: view.topAnchor),
            videoThumbnail.leftAnchor.constraint(equalTo: view.leftAnchor),
            videoThumbnail.rightAnchor.constraint(equalTo: view.rightAnchor),
            videoThumbnail.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            dataScrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            dataScrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            dataScrollView.topAnchor.constraint(equalTo: videoThumbnail.bottomAnchor,
                                                constant: 24),
            dataScrollView.bottomAnchor.constraint(equalTo: previousLessonBtn.topAnchor,
                                                   constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            previousLessonBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            previousLessonBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                      constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            nextLessonBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            nextLessonBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
    }
    
    private func addSubViews(){
        view.addSubview(videoThumbnail)
        view.addSubview(dataScrollView)
        view.addSubview(previousLessonBtn)
        view.addSubview(nextLessonBtn)
    }
    
    private func SetNavBarDownloadBtn(){
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(customView: self.downloadLessonBtn)
        }
    }
}

// MARK: - UI Actions
extension LessonVC{
    /// Updates lesson data
    func updateLesson(to lesson: LessonData){
        self.lesson = lesson
        self.updateLessonUI()
    }
    
    /// Updates the lessonUI to the given lesson data
    private func updateLessonUI(){
        dataScrollView.updateLessonUI(to: lesson.data)
        downloadLessonBtn.updateStatus(to: lesson.donwloadStatus)
        videoThumbnail.updateThumbnail(url: lesson.data.thumbnail)
        
        previousLessonBtn.isHidden = lesson.isFirst
        nextLessonBtn.isHidden = lesson.isLast
    }
    
    @objc
    private func playVideo(){
        delegate?.didTapPlayVideo(in: self)
    }
    
    @objc
    private func didTapPreviousLesson() {
        delegate?.didTapPreviousLesson()
    }
    
    @objc
    private func didTapNextLesson() {
        delegate?.didTapNextLesson()
    }
    
    @objc
    private func didTapDownload() {
        delegate?.didTapDownload()
    }
}

// MARK: - DownloadButtonDelegate
extension LessonVC: DownloadButtonDelegate {
    func didTapDownloadButton() {
        self.delegate?.didTapDownload()
    }
    
    func didUpdateDownloadButton() {
        self.SetNavBarDownloadBtn()
    }
}
