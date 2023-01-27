//
//  ViewController.swift
//  EggTimer
//
//  Created by Андрей Фроленков on 25.01.23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // Vertical StackView
    let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // View For Vertical Stackview
    let topView: UIView = {
        let view = UIView()
        return view
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        return view
    }()
    
    let labelTopView: UILabel = {
        let label = UILabel()
        label.text = "How do you like your eggs?"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 30)
        label.numberOfLines = 0
        label.minimumScaleFactor = 15
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // Horizontal StackView
    let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    // View For Horizontal Stackview
    let leadingView: UIView = {
        let view = UIView()
        return view
    }()
    
    let centerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let trailingView: UIView = {
        let view = UIView()
        return view
    }()
    
    // Buttons For View Horizontal StackView
    lazy var softButton: UIButton = {
        return self.settingButton(title: "Soft", ofSize: 18)
    }()
    
    lazy var mediumButton: UIButton = {
        return self.settingButton(title: "Medium", ofSize: 18)
    }()
    
    lazy var hardButton: UIButton = {
        return self.settingButton(title: "Hard", ofSize: 18)
    }()
    
    // ImageView For Horizontal StackView
    lazy var softImage: UIImageView = {
        return settingImageView(name: "soft_egg")
    }()
    
    lazy var mediumImage: UIImageView = {
        return settingImageView(name: "medium_egg")
    }()
    
    lazy var hardImage: UIImageView = {
        return settingImageView(name: "hard_egg")
    }()
    
    // ProgressView
    let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = .systemYellow
        progressView.trackTintColor = .systemGray
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        return progressView
    }()
    
    let eggTimes = ["Soft": 300, "Medium": 420, "Hard": 720]
    
    var timerOne: Timer?
    // Player
    var player: AVAudioPlayer?
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = #colorLiteral(red: 0.7960784314, green: 0.9490196078, blue: 0.9882352941, alpha: 1)
        addSubviews()
        addSubviewVerticalStackView()
        addSubviewHorizontalStackView()
        setConstraints()
    }
    
    // MARK: Action For Button
    @objc private func hardnessSelected(_ sender: UIButton) {
        
        if let hardness = sender.currentTitle, let time = eggTimes[hardness] {
            
            switch time {
                
            case 300:
                timerStart(timeLeft: 3, name: hardness)
            case 420:
                timerStart(timeLeft: 4, name: hardness)
            case 720:
                timerStart(timeLeft: 7, name: hardness)
            default:
                print("Error")
            }
        }
    }
    
    // MARK: TIMER
    private func timerStart(timeLeft: Int, name: String) {
        
        let timeLeft = timeLeft
        var secondPass = 0
        progressView.progress = 0.0
        labelTopView.text = name
        if let timer = timerOne, timer.isValid {
            timer.invalidate()
        }
        
        timerOne = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {[weak self] timer in
            
            if let self = self {
                secondPass += 1
                let percentageProgress = Float(secondPass) / Float(timeLeft)
                self.progressView.progress = percentageProgress
        
                if secondPass == timeLeft {
                    self.timerOne?.invalidate()
                    self.labelTopView.text = "DONE!"
                    self.playSound("alarm_sound")
                }
            }
            
        })
    }
    
    private func playSound(_ soundName: String) {
        
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    // Setting ImageView
    private func settingImageView(name image: String) -> UIImageView {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    // Settings Button
    private func settingButton(title: String, ofSize: CGFloat ) -> UIButton {
        
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: ofSize, weight: .black)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(hardnessSelected), for: .touchUpInside)
        return button
        
    }
    
    // MARK: addSubviews
    private func addSubviews() {
        
        self.view.addSubview(verticalStackView)
        // Label
        self.topView.addSubview(labelTopView)
        // ProgressView
        self.bottomView.addSubview(progressView)
        // MARK: ImageView
        self.leadingView.addSubview(softImage)
        self.centerView.addSubview(mediumImage)
        self.trailingView.addSubview(hardImage)
        // MARK: Buttons
        self.leadingView.addSubview(softButton)
        self.centerView.addSubview(mediumButton)
        self.trailingView.addSubview(hardButton)
        
        
    }
    
    // MARK: add Subview For Vertical StackView
    private func addSubviewVerticalStackView() {
        
        self.verticalStackView.addArrangedSubview(topView)
        self.verticalStackView.addArrangedSubview(horizontalStackView)
        self.verticalStackView.addArrangedSubview(bottomView)
    }
    
    // MARK: add Subview For Horizontal StackView
    private func addSubviewHorizontalStackView() {
        
        self.horizontalStackView.addArrangedSubview(leadingView)
        self.horizontalStackView.addArrangedSubview(centerView)
        self.horizontalStackView.addArrangedSubview(trailingView)
    }
    
    // MARK: setConstraints
    private func setConstraints() {
        
        // Vertical StackView
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        // Label For topView
        NSLayoutConstraint.activate([
            labelTopView.topAnchor.constraint(equalTo: topView.topAnchor),
            labelTopView.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            labelTopView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            labelTopView.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
        ])
        
        // MARK: Buttons
        // firstButton For leadingView
        NSLayoutConstraint.activate([
            softButton.topAnchor.constraint(equalTo: leadingView.topAnchor),
            softButton.bottomAnchor.constraint(equalTo: leadingView.bottomAnchor),
            softButton.leadingAnchor.constraint(equalTo: leadingView.leadingAnchor),
            softButton.trailingAnchor.constraint(equalTo: leadingView.trailingAnchor),
        ])
        // mediumButton For centerView
        NSLayoutConstraint.activate([
            mediumButton.topAnchor.constraint(equalTo: centerView.topAnchor),
            mediumButton.bottomAnchor.constraint(equalTo: centerView.bottomAnchor),
            mediumButton.leadingAnchor.constraint(equalTo: centerView.leadingAnchor),
            mediumButton.trailingAnchor.constraint(equalTo: centerView.trailingAnchor),
        ])
        // hardButton For trailingView
        NSLayoutConstraint.activate([
            hardButton.topAnchor.constraint(equalTo: trailingView.topAnchor),
            hardButton.bottomAnchor.constraint(equalTo: trailingView.bottomAnchor),
            hardButton.leadingAnchor.constraint(equalTo: trailingView.leadingAnchor),
            hardButton.trailingAnchor.constraint(equalTo: trailingView.trailingAnchor),
        ])
        // MARK: ImageView
        // leadingImage For LeadingView
        NSLayoutConstraint.activate([
            softImage.topAnchor.constraint(equalTo: leadingView.topAnchor),
            softImage.bottomAnchor.constraint(equalTo: leadingView.bottomAnchor),
            softImage.leadingAnchor.constraint(equalTo: leadingView.leadingAnchor),
            softImage.trailingAnchor.constraint(equalTo: leadingView.trailingAnchor),
        ])
        // mediumImage For centerView
        NSLayoutConstraint.activate([
            mediumImage.topAnchor.constraint(equalTo: centerView.topAnchor),
            mediumImage.bottomAnchor.constraint(equalTo: centerView.bottomAnchor),
            mediumImage.leadingAnchor.constraint(equalTo: centerView.leadingAnchor),
            mediumImage.trailingAnchor.constraint(equalTo: centerView.trailingAnchor),
        ])
        // mediumImage For centerView
        NSLayoutConstraint.activate([
            hardImage.topAnchor.constraint(equalTo: trailingView.topAnchor),
            hardImage.bottomAnchor.constraint(equalTo: trailingView.bottomAnchor),
            hardImage.leadingAnchor.constraint(equalTo: trailingView.leadingAnchor),
            hardImage.trailingAnchor.constraint(equalTo: trailingView.trailingAnchor),
        ])
        
        // ProgressView For ButtonView
        NSLayoutConstraint.activate([
            progressView.heightAnchor.constraint(equalToConstant: 5),
            progressView.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            progressView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10),
            progressView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -10),
        ])
    }
    
    
}

