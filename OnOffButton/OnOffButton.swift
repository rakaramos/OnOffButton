//
//  OnOffButton.swift
//  OnOffButton
//
//  Created by Aristóteles on 08/11/14.
//  Copyright (c) 2014 MachadoApps. All rights reserved.
//

import UIKit

class OnOffButton: UIButton {
    
    var onOffLayer = CAShapeLayer()
    
    var onStrokeStart: CGFloat = 0.025
    var onStrokeEnd : CGFloat = 0.22
    var offStrokeStart: CGFloat = 0.268
    var offStrokeEnd: CGFloat = 1.0
    
    let onOffPath: CGPath = {
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 60.48, 17.5)
        CGPathAddLineToPoint(path, nil, 31.63, 46.34)
        CGPathAddLineToPoint(path, nil, 5.05, 19.76)
        CGPathAddCurveToPoint(path, nil, 13.84, 2.51, 34.92, -4.33, 52.15, 4.44)
        CGPathAddCurveToPoint(path, nil, 69.37, 13.22, 76.22, 34.3, 67.44, 51.53)
        CGPathAddCurveToPoint(path, nil, 58.67, 68.75, 37.59, 75.6, 20.36, 66.82)
        CGPathAddCurveToPoint(path, nil, 3.14, 58.05, -3.71, 36.97, 5.07, 19.74)
        return path
        }()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTarget(self, action: "checkUncheck:", forControlEvents:.TouchUpInside)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    override func awakeFromNib() {
        setup()
    }
    
    func setup() {

        onOffLayer.path = scalePathWithBoudingBoxForFrame(path: onOffPath,frame: self.bounds)
        
        onOffLayer.fillColor = nil
        onOffLayer.strokeColor = UIColor.whiteColor().CGColor
        onOffLayer.lineWidth = 6
        onOffLayer.miterLimit = 6
        onOffLayer.lineCap = kCALineCapRound
        onOffLayer.masksToBounds = true
        
        let strokingPath = CGPathCreateCopyByStrokingPath(onOffLayer.path, nil, 6, kCGLineCapRound, kCGLineJoinMiter, 6)
        
        onOffLayer.bounds = CGPathGetPathBoundingBox(strokingPath)
        onOffLayer.position = CGPoint(x: CGRectGetMidX(onOffLayer.bounds), y: CGRectGetMidY(onOffLayer.bounds))
        
        onOffLayer.strokeStart = onStrokeStart
        onOffLayer.strokeEnd = onStrokeEnd

        self.layer.addSublayer(onOffLayer)
        
        addTarget(self, action: "checkUncheck:", forControlEvents:.TouchUpInside)
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
    
    //scaling :http://www.google.com/url?q=http%3A%2F%2Fstackoverflow.com%2Fquestions%2F15643626%2Fscale-cgpath-to-fit-uiview&sa=D&sntz=1&usg=AFQjCNGKPDZfy0-_lkrj3IfWrTGp96QIFQ
    //nice answer from David Rönnqvist!
    func scalePathWithBoudingBoxForFrame(#path: CGPath, frame: CGRect) -> CGPath{
        let boundingBox = CGPathGetBoundingBox(path);
        let boundingBoxAspectRatio = CGRectGetWidth(boundingBox)/CGRectGetHeight(boundingBox);
        let viewAspectRatio = CGRectGetWidth(frame)/CGRectGetHeight(frame);
        
        var scaleFactor: CGFloat = 1.0;
        if (boundingBoxAspectRatio > viewAspectRatio) {
            // Width is limiting factor
            scaleFactor = CGRectGetWidth(frame)/CGRectGetWidth(boundingBox);
        } else {
            // Height is limiting factor
            scaleFactor = CGRectGetHeight(frame)/CGRectGetHeight(boundingBox);
        }
        
        // Scaling the path ...
        var scaleTransform = CGAffineTransformIdentity;
        // Scale down the path first
        scaleTransform = CGAffineTransformScale(scaleTransform, scaleFactor, scaleFactor);
        // Then translate the path to the upper left corner
        scaleTransform = CGAffineTransformTranslate(scaleTransform, -CGRectGetMinX(boundingBox), -CGRectGetMinY(boundingBox));
        
        // If you want to be fancy you could also center the path in the view
        // i.e. if you don't want it to stick to the top.
        // It is done by calculating the heigth and width difference and translating
        // half the scaled value of that in both x and y (the scaled side will be 0)
        let scaledSize = CGSizeApplyAffineTransform(boundingBox.size, CGAffineTransformMakeScale(scaleFactor, scaleFactor));
        let centerOffset = CGSizeMake((CGRectGetWidth(frame)-scaledSize.width)/(scaleFactor*2.0), (CGRectGetHeight(frame)-scaledSize.height)/(scaleFactor*2.0));
        scaleTransform = CGAffineTransformTranslate(scaleTransform, centerOffset.width, centerOffset.height);
        // End of "center in view" transformation code
        
        return CGPathCreateCopyByTransformingPath(path, &scaleTransform);
    }
    
}
//helper
extension CALayer {
    func applyAnimation(animation: CABasicAnimation) {
        let copy = animation.copy() as CABasicAnimation
        if copy.fromValue == nil {
            copy.fromValue = self.presentationLayer().valueForKeyPath(copy.keyPath)
        }
        
        self.addAnimation(copy, forKey: copy.keyPath)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.setValue(copy.toValue, forKeyPath:copy.keyPath)
        CATransaction.commit()
    }
}


