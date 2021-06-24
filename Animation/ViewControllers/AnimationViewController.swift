//
//  AnimationViewController.swift
//  Animation
//
//  Created by SERGEY VOROBEV on 22.06.2021.
//

import UIKit
import Spring

class AnimationViewController: UIViewController {
    // MARK: - Properties
    private var currentAnimationId = 0
    private var currentCurveId = 0
    
    private let smiles = ["😀", "😱", "👍", "😎", "👋", "🤓", "👨‍💻"]
    
    private let defaultAnimationConfiguration = AnimationConfiguration()
    
    private let animations: [Spring.AnimationPreset] = [
        .Shake,
        .Pop,
        .Morph,
        .Squeeze,
        .Wobble,
        .Swing,
        .FlipX,
        .FlipY,
        .Fall,
        .SqueezeLeft,
        .SqueezeRight,
        .SqueezeDown,
        .SqueezeUp,
        .SlideLeft,
        .SlideRight,
        .SlideDown,
        .SlideUp,
        .FadeIn,
        .FadeOut,
        .FadeInLeft,
        .FadeInRight,
        .FadeInDown,
        .FadeInUp,
        .ZoomIn,
        .ZoomOut,
        .Flash
    ]
    
    private let animationCurves: [Spring.AnimationCurve] = [
        .EaseIn,
        .EaseOut,
        .EaseInOut,
        .Linear,
        .Spring,
        .EaseInSine,
        .EaseOutSine,
        .EaseInOutSine,
        .EaseInQuad,
        .EaseOutQuad,
        .EaseInOutQuad,
        .EaseInCubic,
        .EaseOutCubic,
        .EaseInOutCubic,
        .EaseInQuart,
        .EaseOutQuart,
        .EaseInOutQuart,
        .EaseInQuint,
        .EaseOutQuint,
        .EaseInOutQuint,
        .EaseInExpo,
        .EaseOutExpo,
        .EaseInOutExpo,
        .EaseInCirc,
        .EaseOutCirc,
        .EaseInOutCirc,
        .EaseInBack,
        .EaseOutBack,
        .EaseInOutBack
    ]
    
    // MARK: - IBOutlets
    @IBOutlet weak var animationView: SpringView!
    @IBOutlet weak var startButton: SpringButton!
    
    @IBOutlet weak var animationNameLabel: UILabel!
    @IBOutlet weak var animationDescriptionLabel: UILabel!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        configureAnimation(with: defaultAnimationConfiguration)
        //drawCurvedPath()
        animatePlane()
        
        configureAnimationDescription(name: defaultAnimationConfiguration.animation.rawValue, description: defaultAnimationConfiguration.curve.rawValue)
    }
    
    // MARK: - Methods
    private func configure() {
        animationView.backgroundColor = UIColor(named: "Background")
        animationView.layer.cornerRadius = animationView.frame.width / 2
        
        startButton.backgroundColor = UIColor(named: "ButtonBackground")
        startButton.setTitleColor(UIColor(named: "ButtonTextColor"), for: .normal)
        startButton.layer.cornerRadius = 10
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        
        animationNameLabel.textColor = UIColor(named: "TextColor")
        animationDescriptionLabel.textColor = UIColor(named: "TextColor")
        
        animationNameLabel.text = ""
        animationDescriptionLabel.text = ""
        startButton.setTitle("Start with \(defaultAnimationConfiguration.animation.rawValue)", for: .normal)
    }
    
    private func animateSmile() {
        let smileLabel = SpringLabel(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        
        smileLabel.text = smiles.randomElement()
        smileLabel.textAlignment = .center
        smileLabel.font = UIFont.systemFont(ofSize: 35)
        
        view.addSubview(smileLabel)
        
        smileLabel.center = view.center
        
        smileLabel.animation = Spring.AnimationPreset.FadeOut.rawValue
        smileLabel.curve = Spring.AnimationCurve.EaseOutExpo.rawValue
        smileLabel.duration = 2.2
        smileLabel.scaleX = 5.0
        smileLabel.scaleY = 5.0
        smileLabel.velocity = 1.0
        
        smileLabel.animateNext {
            smileLabel.removeFromSuperview()
        }
    }
    
    private func configureAnimation(with configuration: AnimationConfiguration) {
        animationView.force = configuration.force
        animationView.duration = configuration.duration
        animationView.delay = configuration.delay
        
        animationView.damping = configuration.damping
        animationView.velocity = configuration.velocity
        animationView.scaleX = configuration.scaleX
        animationView.scaleY = configuration.scaleY
        animationView.x = configuration.x
        animationView.y = configuration.y
        animationView.rotate = configuration.rotate
        
        animationView.animation = configuration.animation.rawValue
        animationView.curve = configuration.curve.rawValue
    }
    
    private func configureAnimationDescription(name: String, description: String) {
        animationNameLabel.text = name
        animationDescriptionLabel.text = description
    }
    
    private func animateStartButton() {
        startButton.animation = Spring.AnimationPreset.Pop.rawValue
        startButton.animate()
    }
    
    private func drawCurvedPath() -> UIBezierPath {
        let path = createCirclePath()
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 0.0
        
        view.layer.addSublayer(shapeLayer)
        
        return path
    }
    
    private func animatePlane() {
        let moveByCirclePath = CAKeyframeAnimation(keyPath: "position")
        moveByCirclePath.path = drawCurvedPath().cgPath
        moveByCirclePath.duration = 7
        moveByCirclePath.rotationMode = .rotateAuto
        moveByCirclePath.repeatCount = .infinity
        moveByCirclePath.calculationMode = .paced
        moveByCirclePath.timingFunctions = [CAMediaTimingFunction(name: .easeOut)]
        
        startPlaneAnimation(animation: moveByCirclePath)
    }
    
    private func startPlaneAnimation(animation: CAKeyframeAnimation) {
        let plane = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        plane.image = UIImage(named: "Airplane")
        
        view.addSubview(plane)
        
        plane.layer.add(animation, forKey: "animate along path")
    }
    
    private func createCirclePath() -> UIBezierPath {
        let path = UIBezierPath()
        let circleRadius = (animationView.frame.width / 2) + 50
        
        path.addArc(withCenter: CGPoint(x: view.center.x, y: animationView.frame.midY), radius: circleRadius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        
        return path
    }
        
    // MARK: - IBActions
    @IBAction func startButtonTapped(_ sender: SpringButton) {
        var animationConfiguration = AnimationConfiguration()

        // prevent for index out of range
        if currentAnimationId >= animations.count - 1 {
            currentAnimationId = 0
        }
        if currentCurveId >= animationCurves.count - 1 {
            currentCurveId = 0
        }
        
        animateStartButton()
        animateSmile()
        
        configureAnimationDescription(name: animations[currentAnimationId].rawValue, description: animationCurves[currentAnimationId].rawValue)
        
        animationConfiguration.animation = animations[currentAnimationId]
        animationConfiguration.curve = animationCurves[currentCurveId]
        
        // next animation and curve
        currentAnimationId += 1
        currentCurveId += 1
        
        configureAnimation(with: animationConfiguration)
        
        animationView.animate()
        
        startButton.setTitle("Next with \(animations[currentAnimationId].rawValue)", for: .normal)
    }
    
    @IBAction func resetButton() {
        configureAnimation(with: defaultAnimationConfiguration)
        currentAnimationId = 0
        currentCurveId = 0
        
        startButton.setTitle("Start with \(animations[currentAnimationId].rawValue)", for: .normal)
    }
    
}

