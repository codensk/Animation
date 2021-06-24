//
//  AnimationConfiguration.swift
//  Animation
//
//  Created by SERGEY VOROBEV on 22.06.2021.
//

import Foundation
import Spring

struct AnimationConfiguration {
    var force: CGFloat = 1.0
    var duration: CGFloat = 1.0
    var delay: CGFloat = 0.0
    
    var damping: CGFloat = 0.7
    var velocity: CGFloat = 0.7
    var scaleX: CGFloat = 1.0
    var scaleY: CGFloat = 1.0
    var x: CGFloat = 0.0
    var y: CGFloat = 0.0
    var rotate: CGFloat = 0.0
    
    var animation: Spring.AnimationPreset = .Shake
    var curve: Spring.AnimationCurve = .EaseIn
}
