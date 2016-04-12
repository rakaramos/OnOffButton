//
//  Extensions.swift
//  OnOffButton
//
//  Created by Rafael Machado on 2/7/15.
//  Copyright (c) 2015 Rafael Machado. All rights reserved.
//
import UIKit

extension CALayer {
    func applyAnimation(animation: CABasicAnimation) {
        let copy = animation.copy() as? CABasicAnimation ?? CABasicAnimation()
        if copy.fromValue == nil, let presentationLayer = presentationLayer() {
            copy.fromValue = presentationLayer.valueForKeyPath(copy.keyPath ?? "")
        }
        self.addAnimation(copy, forKey: copy.keyPath)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.setValue(copy.toValue, forKeyPath:copy.keyPath ??  "")
        CATransaction.commit()

    }
}

extension CGPath {
    //scaling :http://www.google.com/url?q=http%3A%2F%2Fstackoverflow.com%2Fquestions%2F15643626%2Fscale-cgpath-to-fit-uiview&sa=D&sntz=1&usg=AFQjCNGKPDZfy0-_lkrj3IfWrTGp96QIFQ
    //nice answer from David Rönnqvist!
    class func rescaleForFrame(path: CGPath, frame: CGRect) -> CGPath {
        let boundingBox = CGPathGetBoundingBox(path)
        let boundingBoxAspectRatio = CGRectGetWidth(boundingBox)/CGRectGetHeight(boundingBox)
        let viewAspectRatio = CGRectGetWidth(frame)/CGRectGetHeight(frame)
        
        var scaleFactor: CGFloat = 1.0;
        if (boundingBoxAspectRatio > viewAspectRatio) {
            scaleFactor = CGRectGetWidth(frame)/CGRectGetWidth(boundingBox)
        } else {
            scaleFactor = CGRectGetHeight(frame)/CGRectGetHeight(boundingBox)
        }
        
        var scaleTransform = CGAffineTransformIdentity
        scaleTransform = CGAffineTransformScale(scaleTransform, scaleFactor, scaleFactor)
        scaleTransform = CGAffineTransformTranslate(scaleTransform, -CGRectGetMinX(boundingBox), -CGRectGetMinY(boundingBox))
        let scaledSize = CGSizeApplyAffineTransform(boundingBox.size, CGAffineTransformMakeScale(scaleFactor, scaleFactor))
        let centerOffset = CGSizeMake((CGRectGetWidth(frame)-scaledSize.width)/(scaleFactor*2.0), (CGRectGetHeight(frame)-scaledSize.height)/(scaleFactor*2.0))
        scaleTransform = CGAffineTransformTranslate(scaleTransform, centerOffset.width, centerOffset.height)
        if let resultPath = CGPathCreateCopyByTransformingPath(path, &scaleTransform) {
            return resultPath
        }
        
        return path
    }
}