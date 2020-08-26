//
//  ViewController.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/24/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie

class ViewController: UIViewController {

let api: Provider<APITarget> = ProviderAPIBasic<APITarget>()
    
    @IBOutlet weak var animationView: AnimationView!
    var displayLink: CADisplayLink?
    @IBOutlet weak var logoContraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let animation = Animation.named("30173-welcome-screen")
          
          animationView.animation = animation
        let redValueProvider = ColorValueProvider(Color(r: 1, g: 0.2, b: 0.3, a: 1))
        animationView.backgroundBehavior = .pauseAndRestore

        animationView.setValueProvider(redValueProvider, keypath: AnimationKeypath(keypath: "Switch Outline Outlines.**.Fill 1.Color"))
        animationView.setValueProvider(redValueProvider, keypath: AnimationKeypath(keypath: "Checkmark Outlines 2.**.Stroke 1.Color"))
        displayLink = CADisplayLink(target: self, selector: #selector(animationCallback))
        displayLink?.add(to: .current,
                        forMode: RunLoop.Mode.default)
    }
    @objc func animationCallback() {
      if animationView.isAnimationPlaying {
      }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.logoContraint.constant = 0.5
        UIView.animate(withDuration: 0.6, animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            self.animationView.play()

        }
        
    }

}

