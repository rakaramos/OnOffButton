//
//  OnOffButton.swift
//  OnOffButton
//
//  Created by Aristóteles on 08/11/14.
//  Copyright (c) 2014 MachadoApps. All rights reserved.
//

import UIKit

@IBDesignable
class OnOffButton: UIButton {
    
    @IBInspectable var lineWidth: CGFloat = 1 {
        didSet {
            updateProperties()
        }
    }
    
    @IBInspectable var strokeColor: UIColor = UIColor.whiteColor() {
        didSet {
            updateProperties()
        }
    }
    
    @IBInspectable var ringAlpha: CGFloat = 0.5 {
        didSet {
            updateProperties()
        }
    }

    private var onOffLayer: CAShapeLayer!
    private var ringLayer: CAShapeLayer!
    private let onStrokeStart: CGFloat = 0.025
    private let onStrokeEnd : CGFloat = 0.20
    private let offStrokeStart: CGFloat = 0.268
    private let offStrokeEnd: CGFloat = 1.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        createLayersIfNeeded()
        updateProperties()
    }
    
    private func createLayersIfNeeded() {
        if onOffLayer == nil {
            onOffLayer = CAShapeLayer()
            onOffLayer.path = CGPath.rescaleForFrame(path: OnOff.innerPath, frame: self.bounds)
            setUpShapeLayer(onOffLayer)
            onOffLayer.strokeColor = strokeColor.CGColor
            let strokingPath = CGPathCreateCopyByStrokingPath(onOffLayer.path, nil, lineWidth, kCGLineCapRound, kCGLineJoinMiter, 10)
            onOffLayer.bounds = CGPathGetPathBoundingBox(strokingPath)
            onOffLayer.position = CGPoint(x: CGRectGetMidX(onOffLayer.bounds), y: CGRectGetMidY(onOffLayer.bounds))
            onOffLayer.strokeStart = onStrokeStart
            onOffLayer.strokeEnd = onStrokeEnd
            self.layer.addSublayer(onOffLayer)
        }
        
        if ringLayer == nil {
            ringLayer = CAShapeLayer()
            setUpShapeLayer(ringLayer)
            ringLayer.strokeColor = ringColorWithAlpha()
            let boundsWithInsets = CGRectInset(onOffLayer.bounds, lineWidth/2, lineWidth/2)
            let ovalPath = OnOff.ringPathForFrame(boundsWithInsets)
            ringLayer.path = ovalPath
            ringLayer.bounds = onOffLayer.bounds
            ringLayer.position = onOffLayer.position
            self.layer.addSublayer(ringLayer)
        }
    }
    
    private func setUpShapeLayer(shapeLayer: CAShapeLayer) {
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = lineWidth
        shapeLayer.miterLimit = 10
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.masksToBounds = false
    }
    
    private func ringColorWithAlpha() -> CGColor {
        return strokeColor.colorWithAlphaComponent(ringAlpha).CGColor
    }
    
    private func updateProperties() {
        if onOffLayer != nil {
            onOffLayer.lineWidth = lineWidth
            onOffLayer.strokeColor = strokeColor.CGColor
        }
        
        if ringLayer != nil {
            ringLayer.lineWidth = lineWidth
            ringLayer.strokeColor = ringColorWithAlpha()
        }
    }
    
    func checkUncheck(sender: AnyObject!) {
        checked = !checked
    }
    
    var checked: Bool = true {
        didSet {
            let strokeStart = CABasicAnimation(keyPath: "strokeStart")
            let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
            
            if self.checked {
                strokeStart.toValue = onStrokeStart
                strokeStart.duration = 0.6
                strokeStart.timingFunction = CAMediaTimingFunction(controlPoints: 0.75,0.1,0.50,1.38)
                
                strokeEnd.toValue = onStrokeEnd
                strokeEnd.duration = 0.6
                strokeEnd.timingFunction = CAMediaTimingFunction(controlPoints: 0.75,0.1,0.50,1.38)
            } else {
                strokeStart.toValue = offStrokeStart
                strokeStart.duration = 0.6
                strokeStart.timingFunction = CAMediaTimingFunction(controlPoints: 0.45,-0.2,0.8,0.65)
                
                strokeEnd.toValue = offStrokeEnd
                strokeEnd.duration = 0.6
                strokeEnd.timingFunction = CAMediaTimingFunction(controlPoints: 0.45,-0.2,0.8,0.65)
            }
            self.onOffLayer.applyAnimation(strokeStart)
            self.onOffLayer.applyAnimation(strokeEnd)
        }
    }
}