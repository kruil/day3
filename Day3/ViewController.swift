//
//  ViewController.swift
//  Day3
//
//  Created by Ilya Krupko on 07.05.23.
//

import UIKit

final class ViewController: UIViewController {
    
    let viewInitialHeight = 100.0
    
    // MARK: Subviews
    private lazy var animatedView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.cornerCurve = .continuous
        view.backgroundColor = .systemMint
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private lazy var propertyAnimator: UIViewPropertyAnimator = {
        let animator  = UIViewPropertyAnimator(duration: 0.2, curve: .linear)
        let transform = CGAffineTransformConcat(
            CGAffineTransform(rotationAngle: .pi / 2),
            CGAffineTransform(scaleX: 1.5, y: 1.5)
        )
        animator.addAnimations { [self] in
            animatedView.transform = transform
        }
        animator.pausesOnCompletion = true
        return animator
    }()
    
    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
        slider.addTarget(self, action: #selector(setToEnd), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderValueCnanged), for: .valueChanged)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let finalRightPosition = view.frame.width - ((animatedView.center.x * 1.5) - view.layoutMargins.right / 2)
        propertyAnimator.addAnimations {
            self.animatedView.center.x = finalRightPosition
        }
    }
    
    private func addSubviews() {
        view.addSubview(animatedView)
        view.addSubview(slider)
    }
    
    private func setupConstraints() {
        lazy var animatedViewFinalCenterY = viewInitialHeight * 1.5 / 2
        NSLayoutConstraint.activate([
            animatedView.heightAnchor.constraint(equalToConstant: viewInitialHeight),
            animatedView.widthAnchor.constraint(equalToConstant: viewInitialHeight),
            animatedView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: animatedViewFinalCenterY + 16),
            animatedView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            slider.topAnchor.constraint(equalTo: animatedView.centerYAnchor, constant: animatedViewFinalCenterY + 16),
            slider.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    @objc
    private func setToEnd() {
        slider.setValue(1, animated: true)
        propertyAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 1)
    }
    
    @objc
    private func sliderValueCnanged(_ sender: UISlider) {
        propertyAnimator.fractionComplete = CGFloat(sender.value)
        print(sender.value)
    }
}

