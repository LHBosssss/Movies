//
//  MoviePlayerViewController.swift
//  Movies
//
//  Created by Ho Duy Luong on 5/9/20.
//  Copyright © 2020 Ho Duy Luong. All rights reserved.
//

import UIKit
import FontAwesome_swift

class MoviePlayerViewController: UIViewController {
    
    var mediaURL: String? {
        didSet {
            guard let media = mediaURL else { return }
            print(media)
            guard let url = URL(string: media) else { return }
            mediaPlayer.media = VLCMedia(url: url)
            mediaPlayer.play()
            progressBar.minimumValue = 0
            progressBar.maximumValue = Float(mediaPlayer.media.length.intValue/1000)
        }
    }
    
    var movieTitle: String? {
        didSet {
            guard let titleString = movieTitle else { return }
            print(titleString)
            titleLabel.text = titleString
        }
    }
    
    var movieSubtitle: String? {
        didSet {
            print("didset")
            guard let sub = movieSubtitle else { return }
            let subURL = URL(fileURLWithPath: sub)
            self.mediaPlayer.addPlaybackSlave(subURL, type: .subtitle, enforce: true)
            print("Sub OK")
        }
    }
    
    private let mediaPlayerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        return view
    }()
    
    private let topBar: UIView = {
        let bar = UIView()
        bar.backgroundColor = UIColor().bgColor()
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.adjustsFontSizeToFitWidth = true
        title.textAlignment = .center
        title.contentMode = .center
        title.numberOfLines = 0
        title.font = UIFont.systemFont(ofSize: 20, weight: .light)
        title.textColor = UIColor().titleColor()
        title.backgroundColor = UIColor().bgColor()
        title.isHidden = false
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private let controlBar: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.isLayoutMarginsRelativeArrangement = true
        stack.alignment = .center
        stack.contentMode = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addBackground(color: UIColor().bgColor())
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let currentTime: UILabel = {
        let currentTime = UILabel()
        currentTime.textColor = UIColor().textColor()
        currentTime.text = "00:00:00"
        currentTime.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        currentTime.numberOfLines = 1
        currentTime.adjustsFontSizeToFitWidth = true
        currentTime.backgroundColor = .clear
        currentTime.textAlignment = .center
        currentTime.translatesAutoresizingMaskIntoConstraints = false
        return currentTime
    }()
    
    private let movieLengthTime: UILabel = {
        let totalTime = UILabel()
        totalTime.textColor = UIColor().textColor()
        totalTime.text = "00:00:00"
        totalTime.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        totalTime.numberOfLines = 1
        totalTime.adjustsFontSizeToFitWidth = true
        totalTime.backgroundColor = .clear
        totalTime.textAlignment = .center
        totalTime.translatesAutoresizingMaskIntoConstraints = false
        return totalTime
    }()
    
    private let progressBar: UISlider = {
        let thumbImage = UIImage.fontAwesomeIcon(name: .circle, style: .solid, textColor: UIColor().titleColor(), size: CGSize(width: 15, height: 15))
        let progress = UISlider()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.setThumbImage(thumbImage, for: .normal)
        progress.isContinuous = true
        progress.tintColor = UIColor.gray
        progress.isHidden = false
        progress.addTarget(self, action: #selector(handleSeeking), for: .valueChanged)
        progress.addTarget(self, action: #selector(didEndSeeking), for: .touchUpInside)
        return progress
    }()
    
    var movieEnTitle: String?
    private let playPauseButton = UIButton().controlButton(name: .pause)
    private let mediaPlayer = VLCMediaPlayer()
    private var isSeeking = false
    private var maxTimeDidSet = false
    var subURL: URL?
    private let aspectRatios = ["DEFAULT", "FILL_TO_SCREEN", "4:3", "16:9", "16:10", "2:1", "20:9", "21:9" , "39:18"]
    private var currentAspectRatioMask = 0
    private var subtitleManger = SubtitleManager()
    private let delayValue = UILabel()
    
    // MARK:- SUPER VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMediaPlayerView()
        setupTitleBar()
        setupControlView()
        setupProgressBarView()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    func setupMediaPlayerView() {
        maxTimeDidSet = false
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        subtitleManger.selectedDelegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        mediaPlayerView.isUserInteractionEnabled = true
        mediaPlayerView.addGestureRecognizer(tapGesture)
        mediaPlayer.drawable = mediaPlayerView
        mediaPlayer.delegate = self
        view.addSubview(mediaPlayerView)
        NSLayoutConstraint.activate([
            mediaPlayerView.topAnchor.constraint(equalTo: view.topAnchor),
            mediaPlayerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mediaPlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mediaPlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupTitleBar() {
        view.addSubview(topBar)
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        topBar.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topBar.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: topBar.bottomAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: topBar.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: topBar.trailingAnchor, constant: -10),
        ])
    }
    
    func setupControlView() {
        view.addSubview(controlBar)
        NSLayoutConstraint.activate([
            controlBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            controlBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controlBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controlBar.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Add Current Time
        controlBar.addArrangedSubview(currentTime)
        currentTime.widthAnchor.constraint(equalToConstant: 60).isActive = true
        currentTime.heightAnchor.constraint(equalTo: controlBar.heightAnchor).isActive = true
        currentTime.centerYAnchor.constraint(equalTo: controlBar.centerYAnchor).isActive = true
        
        // Add Default Size Button
        let defaultSizeButton = UIButton().controlButton(name: .compressArrowsAlt)
        defaultSizeButton.addTarget(self, action: #selector(handleDefaultSize), for: .touchUpInside)
        controlBar.addArrangedSubview(defaultSizeButton)
        defaultSizeButton.heightAnchor.constraint(equalTo: controlBar.heightAnchor).isActive = true
        
        // Add Fit Width Button
        let fitWidthButton = UIButton().controlButton(name: .arrowsAltH)
        fitWidthButton.addTarget(self, action: #selector(handleFitWidth), for: .touchUpInside)
        controlBar.addArrangedSubview(fitWidthButton)
        fitWidthButton.heightAnchor.constraint(equalTo: controlBar.heightAnchor).isActive = true
        
        // Add Fit Height Button
        let fitHeightSizeButton = UIButton().controlButton(name: .arrowsAltV)
        fitHeightSizeButton.addTarget(self, action: #selector(handleFitHeight), for: .touchUpInside)
        controlBar.addArrangedSubview(fitHeightSizeButton)
        fitHeightSizeButton.heightAnchor.constraint(equalTo: controlBar.heightAnchor).isActive = true
        
        // Add Backward Button
        let backwardButton = UIButton().controlButton(name: .backward)
        backwardButton.addTarget(self, action: #selector(handleBackward), for: .touchUpInside)
        controlBar.addArrangedSubview(backwardButton)
        backwardButton.heightAnchor.constraint(equalTo: controlBar.heightAnchor).isActive = true
        
        // Add Play/Pause Button
        playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        controlBar.addArrangedSubview(playPauseButton)
        playPauseButton.heightAnchor.constraint(equalTo: controlBar.heightAnchor).isActive = true
        
        // Add Forward Button
        let forwardButton = UIButton().controlButton(name: .forward)
        forwardButton.addTarget(self, action: #selector(handleForward), for: .touchUpInside)
        controlBar.addArrangedSubview(forwardButton)
        forwardButton.heightAnchor.constraint(equalTo: controlBar.heightAnchor).isActive = true
        
        // Add Stop Button
        let stopButton = UIButton().controlButton(name: .stop)
        stopButton.addTarget(self, action: #selector(handleStop), for: .touchUpInside)
        controlBar.addArrangedSubview(stopButton)
        stopButton.heightAnchor.constraint(equalTo: controlBar.heightAnchor).isActive = true
        
        // Add Subtitle Button
        let subtitleButton = UIButton().controlButton(name: .closedCaptioning)
        subtitleButton.addTarget(self, action: #selector(handleSubtitle), for: .touchUpInside)
        controlBar.addArrangedSubview(subtitleButton)
        subtitleButton.heightAnchor.constraint(equalTo: controlBar.heightAnchor).isActive = true
        
        // Add Total Time
        controlBar.addArrangedSubview(movieLengthTime)
        movieLengthTime.widthAnchor.constraint(equalToConstant: 60).isActive = true
        movieLengthTime.heightAnchor.constraint(equalTo: controlBar.heightAnchor).isActive = true
    }
    
    func setupProgressBarView() {
        view.addSubview(progressBar)
        NSLayoutConstraint.activate([
            progressBar.bottomAnchor.constraint(equalTo: controlBar.topAnchor, constant: 5),
            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    @objc func handleTap() {
        if controlBar.isHidden {
            topBar.isHidden = false
            controlBar.isHidden = false
            progressBar.isHidden = false
            self.topBar.alpha = 1
            self.controlBar.alpha = 1
            self.progressBar.alpha = 1
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.topBar.alpha = 0
                self.controlBar.alpha = 0
                self.progressBar.alpha = 0
            }) { (animated) in
                self.topBar.isHidden = true
                self.controlBar.isHidden = true
                self.progressBar.isHidden = true
            }
            
        }
    }
    
    @objc func handleSeeking() {
        isSeeking = true
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: Int(progressBar.value))
        let time = "\(h >= 0 ? "\(h)" : "" ):\(m >= 10 ? "\(m)" : "\(m)"):\(s > 10 ? "\(s)" : "\(s)")"
        currentTime.text = time
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    @objc func didEndSeeking() {
        isSeeking = false
        let timeToSeek = Int32(progressBar.value)
        print(timeToSeek)
        let timeWillSeek = timeToSeek - mediaPlayer.time.intValue/1000
        print(timeWillSeek)
        if timeWillSeek > 0 {
            self.mediaPlayer.jumpForward(timeWillSeek)
        } else {
            self.mediaPlayer.jumpBackward(-timeWillSeek)
        }
    }
    
    @objc func handleDefaultSize() {
        let count = aspectRatios.count
        
        if (currentAspectRatioMask + 1 > count - 1) {
            mediaPlayer.videoAspectRatio = nil;
            mediaPlayer.videoCropGeometry = nil;
            currentAspectRatioMask = 0;
            print("crop disabled");
        } else {
            currentAspectRatioMask += 1;
            if (aspectRatios[currentAspectRatioMask] == "FILL_TO_SCREEN") {
                let screen = UIScreen.main
                let f_ar = screen.bounds.size.width / screen.bounds.size.height;
                mediaPlayer.scaleFactor = 0
                mediaPlayer.videoCropGeometry = nil
                mediaPlayer.videoAspectRatio = nil
                if (f_ar == (3.0/2.0)) {
                    let cs = ("16:10" as NSString).utf8String
                    let buffer = UnsafeMutablePointer<Int8>(mutating: cs)
                    mediaPlayer.videoCropGeometry = buffer
                } // all other iPhones
                else if (f_ar == (2688/1242)) {
                    let cs = ("39:18" as NSString).utf8String
                    let buffer = UnsafeMutablePointer<Int8>(mutating: cs)
                    mediaPlayer.videoCropGeometry = buffer
                }
                else if (f_ar == (1.25)) {
                    let cs = ("4:3" as NSString).utf8String
                    let buffer = UnsafeMutablePointer<Int8>(mutating: cs)
                    mediaPlayer.videoCropGeometry = buffer
                }
                else {
                    print("unknown screen format %f, can't crop", f_ar);
                }
                return
            }
            mediaPlayer.scaleFactor = 0
            mediaPlayer.videoCropGeometry = nil
            mediaPlayer.videoAspectRatio = UnsafeMutablePointer<Int8>(mutating: (aspectRatios[currentAspectRatioMask] as NSString).utf8String)
            print("crop switched to ", aspectRatios[currentAspectRatioMask]);
        }
    }
    
    @objc func handleFitWidth() {
        mediaPlayer.videoCropGeometry = nil
        mediaPlayer.videoAspectRatio = nil
        if mediaPlayer.scaleFactor != 0 {
            mediaPlayer.scaleFactor = 0
        } else {
            let screenScale = UIScreen.main.scale
            let videoWidth = mediaPlayer.videoSize.width
            let screenWidth = UIScreen.main.bounds.width * screenScale
            let willScale = screenWidth / videoWidth
            mediaPlayer.scaleFactor = Float(willScale)
        }
    }
    
    @objc func handleFitHeight() {
        mediaPlayer.videoCropGeometry = nil
        mediaPlayer.videoAspectRatio = nil
        if mediaPlayer.scaleFactor != 0 {
            mediaPlayer.scaleFactor = 0
        } else {
            let screenScale = UIScreen.main.scale
            let videoHeight = mediaPlayer.videoSize.height
            let screenHeight = UIScreen.main.bounds.height * screenScale
            let willScale = screenHeight / videoHeight
            mediaPlayer.scaleFactor = Float(willScale)
        }
    }
    
    @objc func handleBackward() {
        mediaPlayer.jumpBackward(10)
    }
    
    @objc func handlePlayPause() {
        print("Play pause tapped: \(mediaPlayer.state)")
        if mediaPlayer.isPlaying {
            print("pause")
            mediaPlayer.pause()
            playPauseButton.setTitle(String.fontAwesomeIcon(name: .play), for: .normal)
        } else {
            print("play")
            mediaPlayer.play()
            playPauseButton.setTitle(String.fontAwesomeIcon(name: .pause), for: .normal)
        }
    }
    
    @objc func handleForward() {
        mediaPlayer.jumpForward(10)
    }
    
    @objc func handleStop() {
        print("Stop")
        self.mediaPlayer.stop()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSubtitle() {
        
        let subtitleAlert = UIAlertController(title: "\n\n", message: nil, preferredStyle: .actionSheet)
        // Subtitle Delay
        let label = UILabel()
        label.text = "Subtitle Delay"
        label.textAlignment = .center
        let stepper = UIStepper()
        stepper.addTarget(self, action: #selector(handleStepper(_:)), for: .valueChanged)
        stepper.minimumValue = -15
        stepper.maximumValue = 15
        stepper.stepValue = 0.5
        stepper.value = Double(self.mediaPlayer.currentVideoSubTitleDelay / 1000000)
        
        delayValue.text = String(stepper.value)
        delayValue.textAlignment = .right
        
        let subtitleDelayStack = UIStackView()
        subtitleDelayStack.distribution = .equalCentering
        subtitleDelayStack.translatesAutoresizingMaskIntoConstraints = false
        
        subtitleDelayStack.addArrangedSubview(stepper)
        subtitleDelayStack.addArrangedSubview(label)
        subtitleDelayStack.addArrangedSubview(delayValue)
        
        subtitleAlert.view.addSubview(subtitleDelayStack)
        subtitleDelayStack.leadingAnchor.constraint(equalTo: subtitleAlert.view.leadingAnchor, constant: 20).isActive = true
        subtitleDelayStack.trailingAnchor.constraint(equalTo: subtitleAlert.view.trailingAnchor, constant: -20).isActive = true
        subtitleDelayStack.topAnchor.constraint(equalTo: subtitleAlert.view.topAnchor, constant: 20).isActive = true

        
        
        let selectSubtitle = UIAlertAction(title: "Select Subtitle", style: .default) { (_) in
            let listSubtitle = UIAlertController(title: "Select Manager", message: nil, preferredStyle: .actionSheet)
            guard let listName: [String] = self.mediaPlayer.videoSubTitlesNames as? [String] else {return}
            guard let listIndex: [Int32] = self.mediaPlayer.videoSubTitlesIndexes as? [Int32] else {return}
            var index = 0
            for item in listName {
                let currentIndex = index
                let sub = UIAlertAction(title: item, style: .default) { (_) in
                    let subIndex = currentIndex
                    self.mediaPlayer.currentVideoSubTitleIndex = listIndex[subIndex]
                    print(self.mediaPlayer.currentVideoSubTitleIndex)
                }
                print(index)
                index += 1
                listSubtitle.addAction(sub)
            }
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            listSubtitle.addAction(cancelButton)
            self.present(listSubtitle, animated: true, completion: nil)
        }
        let downloadSubtitle = UIAlertAction(title: "Download Subtitle", style: .default) { (_) in
            print("Download Subtitle")
            let vc = SubtitleSearchViewController()
            vc.subtitleManager = self.subtitleManger
            vc.titleToSearch = self.movieEnTitle
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        subtitleAlert.addAction(selectSubtitle)
        subtitleAlert.addAction(downloadSubtitle)
        subtitleAlert.addAction(cancelButton)
        
        present(subtitleAlert, animated: true, completion: nil)
        
        
    }
    
    @objc func handleStepper(_ stepper: UIStepper) {
        self.delayValue.text = String(stepper.value)
        self.mediaPlayer.currentVideoSubTitleDelay = Int(stepper.value * 1000000)
        print(self.mediaPlayer.currentVideoSubTitleDelay)
    }
    
}

extension MoviePlayerViewController: VLCMediaPlayerDelegate {
    
    func mediaPlayerStateChanged(_ aNotification: Notification!) {
        if mediaPlayer.state == .stopped {
            print("Stopped")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func mediaPlayerTimeChanged(_ aNotification: Notification!) {
        
        if !isSeeking {
            currentTime.text = mediaPlayer.time.stringValue
            progressBar.value = Float(self.mediaPlayer.time.intValue / 1000)
        }
        
        if !maxTimeDidSet {
            if let sub = subURL {
                self.mediaPlayer.addPlaybackSlave(sub, type: .subtitle, enforce: true)
            }
            print(mediaPlayer.media.length.intValue / 1000)
            self.progressBar.maximumValue = Float(mediaPlayer.media.length.intValue / 1000)
            self.movieLengthTime.text = mediaPlayer.media.length.stringValue
            maxTimeDidSet = true
        }
    }
}

extension MoviePlayerViewController: SelectedSubtitleDelegate {
    func didSelectSubtitle(filePath: String) {
        print("Selected and go to Movie Player")
        print(filePath)
        guard let subURL = URL(string: filePath) else { return }
        print(subURL)
        mediaPlayer.addPlaybackSlave(subURL, type: .subtitle, enforce: true)
        print("Sub OK")
        self.movieSubtitle = filePath
    }
}

extension UIButton {
    func controlButton(name: FontAwesome) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = true
        button.titleLabel?.font = UIFont.fontAwesome(ofSize: 35, style: .solid)
        button.setTitle(String.fontAwesomeIcon(name: name), for: .normal)
        button.setTitleColor(UIColor().textColor(), for: .normal)
        button.setTitleColor(UIColor().buttonColor(), for: .selected)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.backgroundColor = .none
        button.backgroundColor = .none
        return button
    }
}

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
