//
//  AnimationsManager.swift
//  DoReMi
//
//  Created by Conor Smith on 7/1/21.
//

import Foundation
import UIKit

final class AnimationsManager {
    static let shared = AnimationsManager()
    
    private init() {}
    
    //Public
    
    public func performClockwiseAnimation(imgView: UIImageView) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            imgView.transform = imgView.transform.rotated(by: .pi / 2)
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                imgView.transform = imgView.transform.rotated(by: .pi / 2)
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                    imgView.transform = imgView.transform.rotated(by: .pi / 2)
                    UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                        imgView.transform = imgView.transform.rotated(by: .pi / 2)
                    })
                })
            })
        })
    }
    
    public func performCounterClockwiseAnimation(imgView: UIImageView) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            imgView.transform = imgView.transform.rotated(by: -.pi / 2)
            UIView.animate(withDuration: 0.3, delay: 0.05, options: .curveEaseInOut, animations: {
                imgView.transform = imgView.transform.rotated(by: -.pi / 2)
                UIView.animate(withDuration: 0.3, delay: 0.05, options: .curveEaseInOut, animations: {
                    imgView.transform = imgView.transform.rotated(by: -.pi / 2)
                    UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                        imgView.transform = imgView.transform.rotated(by: -.pi / 2)
                    })
                })
            })
        })
    }
    
    public func performSpringAnimation(imgView: UIImageView) {
        UIView.animate(withDuration: 0.5, delay: 0,usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5,  options: .curveEaseInOut, animations: {
            imgView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            UIView.animate(withDuration: 0.7, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                imgView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            })
        })
    }
    
    public func performReverseSpringAnimation(imgView: UIImageView) {
        UIView.animate(withDuration: 0.7, delay: 0,usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5,  options: .curveEaseInOut, animations: {
            imgView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                imgView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            })
        })
    }
    
    public func shimmerAnimation() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemGray6.cgColor, UIColor.systemGray5.cgColor, UIColor.systemGray6.cgColor]
        gradientLayer.locations = [0, 0.5, 1]
        
        let angle = 75 * CGFloat.pi / 180
        gradientLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        
        return gradientLayer
        
    }
}
