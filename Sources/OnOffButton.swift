import UIKit

@IBDesignable
public class OnOffButton: UIButton {
    
    // MARK: Inspectables
    
    @IBInspectable public var lineWidth: CGFloat = 1 {
        didSet {
            updateProperties()
        }
    }
    
    @IBInspectable public var strokeColor: UIColor = UIColor.whiteColor() {
        didSet {
            updateProperties()
        }
    }
    
    @IBInspectable public var ringAlpha: CGFloat = 0.5 {
        didSet {
            updateProperties()
        }
    }
    
    // MARK: Variables
    
    public var checked: Bool = true {
        didSet {
            var strokeStart = CABasicAnimation()
            var strokeEnd = CABasicAnimation()
            if checked {
                let animations = checkedAnimation()
                strokeStart    = animations.strokeStart
                strokeEnd      = animations.strokeEnd
            }
            else {
                let animations = unchekedAnimation()
                strokeStart    = animations.strokeStart
                strokeEnd      = animations.strokeEnd
            }
            onOffLayer.applyAnimation(strokeStart)
            onOffLayer.applyAnimation(strokeEnd)
        }
    }
    
    private var onOffLayer: CAShapeLayer!
    private var ringLayer: CAShapeLayer!
    private let onStrokeStart: CGFloat  = 0.025
    private let onStrokeEnd : CGFloat   = 0.20
    private let offStrokeStart: CGFloat = 0.268
    private let offStrokeEnd: CGFloat   = 1.0
    private let miterLimit: CGFloat     = 10
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateProperties()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateProperties()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        updateProperties()
    }
    
    // MARK: Layout
    
    private func updateProperties() {
        // using init() will raise CGPostError, lets prevent it
        if bounds == CGRectZero { return }
        
        createLayersIfNeeded()
        if onOffLayer != nil {
            onOffLayer.lineWidth   = lineWidth
            onOffLayer.strokeColor = strokeColor.CGColor
        }
        
        if ringLayer != nil {
            ringLayer.lineWidth   = lineWidth
            ringLayer.strokeColor = ringColorWithAlpha()
        }
    }
    
    // MARK: Layer Set Up
    
    private func createLayersIfNeeded() {
        if onOffLayer == nil {
            onOffLayer = createOnOffLayer()
            layer.addSublayer(onOffLayer)
        }
        
        if ringLayer == nil {
            ringLayer = createRingLayer()
            layer.addSublayer(ringLayer)
        }
    }

    private func createOnOffLayer() -> CAShapeLayer {
        let onOffLayer = CAShapeLayer()
        onOffLayer.path = CGPath.rescaleForFrame(OnOff.innerPath, frame: self.bounds)
        
        let strokingPath       = CGPathCreateCopyByStrokingPath(onOffLayer.path, nil, lineWidth, .Round, .Miter, miterLimit)
        onOffLayer.bounds      = CGPathGetPathBoundingBox(strokingPath)
        onOffLayer.position    = CGPoint(x: CGRectGetMidX(onOffLayer.bounds), y: CGRectGetMidY(onOffLayer.bounds))
        onOffLayer.strokeStart = onStrokeStart
        onOffLayer.strokeEnd   = onStrokeEnd
        onOffLayer.strokeColor = strokeColor.CGColor
        setUpShapeLayer(onOffLayer)
        
        return onOffLayer
    }
    
    private func createRingLayer() -> CAShapeLayer {
        let ringLayer = CAShapeLayer()
        let boundsWithInsets  = CGRectInset(onOffLayer.bounds, lineWidth/2, lineWidth/2)
        let ovalPath          = OnOff.ringPathForFrame(boundsWithInsets)
        ringLayer.path        = ovalPath
        ringLayer.bounds      = onOffLayer.bounds
        ringLayer.position    = onOffLayer.position
        ringLayer.strokeColor = ringColorWithAlpha()
        setUpShapeLayer(ringLayer)
        
        return ringLayer
    }
    
    private func setUpShapeLayer(shapeLayer: CAShapeLayer) {
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = lineWidth
        shapeLayer.miterLimit = miterLimit
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.masksToBounds = false
    }
    
    private func ringColorWithAlpha() -> CGColor {
        return strokeColor.colorWithAlphaComponent(ringAlpha).CGColor
    }
    
    // MARK: Animations
    
    private func checkedAnimation() -> (strokeStart: CABasicAnimation, strokeEnd: CABasicAnimation) {
        let strokeStart            = CABasicAnimation(keyPath: "strokeStart")
        strokeStart.toValue        = onStrokeStart
        strokeStart.duration       = 0.6
        strokeStart.timingFunction = CAMediaTimingFunction(controlPoints: 0.75, 0.1, 0.50, 1.38)
        
        let strokeEnd            = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.toValue        = onStrokeEnd
        strokeEnd.duration       = 0.6
        strokeEnd.timingFunction = CAMediaTimingFunction(controlPoints: 0.75, 0.1, 0.50, 1.38)
        
        return (strokeStart, strokeEnd)
    }
    
    private func unchekedAnimation() -> (strokeStart: CABasicAnimation, strokeEnd: CABasicAnimation) {
        let strokeStart            = CABasicAnimation(keyPath: "strokeStart")
        strokeStart.toValue        = offStrokeStart
        strokeStart.duration       = 0.6
        strokeStart.timingFunction = CAMediaTimingFunction(controlPoints: 0.45, -0.2, 0.8, 0.65)
        
        let strokeEnd            = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.toValue        = offStrokeEnd
        strokeEnd.duration       = 0.6
        strokeEnd.timingFunction = CAMediaTimingFunction(controlPoints: 0.45, -0.2, 0.8, 0.65)
        
        return (strokeStart, strokeEnd)
    }
}

// MARK: Path

struct OnOff {
    static var innerPath: CGPath {
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 60.48, 17.5)
        CGPathAddLineToPoint(path, nil, 31.63, 46.34)
        CGPathAddLineToPoint(path, nil, 5.05, 19.76)
        CGPathAddCurveToPoint(path, nil, 13.84, 2.51, 34.92, -4.33, 52.15, 4.44)
        CGPathAddCurveToPoint(path, nil, 69.37, 13.22, 76.22, 34.3, 67.44, 51.53)
        CGPathAddCurveToPoint(path, nil, 58.67, 68.75, 37.59, 75.6, 20.36, 66.82)
        CGPathAddCurveToPoint(path, nil, 3.14, 58.05, -3.71, 36.97, 5.07, 19.74)
        return path
    }
    
    static func ringPathForFrame(frame: CGRect) -> CGPath {
        let outerPath = UIBezierPath(ovalInRect: frame)
        return outerPath.CGPath
    }
}

// MARK: Extensions

extension CALayer {
    func applyAnimation(animation: CABasicAnimation) {
        let copy = animation.copy() as? CABasicAnimation ?? CABasicAnimation()
        if  copy.fromValue == nil,
            let presentationLayer = presentationLayer() {
            copy.fromValue = presentationLayer.valueForKeyPath(copy.keyPath ?? "")
        }
        addAnimation(copy, forKey: copy.keyPath)
        performWithoutAnimation {
            self.setValue(copy.toValue, forKeyPath:copy.keyPath ??  "")
        }
    }
    
    func performWithoutAnimation(closure: Void -> Void) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        closure()
        CATransaction.commit()
    }
}

extension CGPath {
    //scaling :http://www.google.com/url?q=http%3A%2F%2Fstackoverflow.com%2Fquestions%2F15643626%2Fscale-cgpath-to-fit-uiview&sa=D&sntz=1&usg=AFQjCNGKPDZfy0-_lkrj3IfWrTGp96QIFQ
    //nice answer from David Rönnqvist!
    class func rescaleForFrame(path: CGPath, frame: CGRect) -> CGPath {
        let boundingBox            = CGPathGetBoundingBox(path)
        let boundingBoxAspectRatio = CGRectGetWidth(boundingBox)/CGRectGetHeight(boundingBox)
        let viewAspectRatio        = CGRectGetWidth(frame)/CGRectGetHeight(frame)
        
        var scaleFactor: CGFloat = 1.0
        if (boundingBoxAspectRatio > viewAspectRatio) {
            scaleFactor = CGRectGetWidth(frame)/CGRectGetWidth(boundingBox)
        } else {
            scaleFactor = CGRectGetHeight(frame)/CGRectGetHeight(boundingBox)
        }
        
        var scaleTransform = CGAffineTransformIdentity
        scaleTransform     = CGAffineTransformScale(scaleTransform, scaleFactor, scaleFactor)
        scaleTransform     = CGAffineTransformTranslate(scaleTransform, -CGRectGetMinX(boundingBox), -CGRectGetMinY(boundingBox))
        let scaledSize     = CGSizeApplyAffineTransform(boundingBox.size, CGAffineTransformMakeScale(scaleFactor, scaleFactor))
        let centerOffset   = CGSizeMake((CGRectGetWidth(frame)-scaledSize.width)/(scaleFactor*2.0), (CGRectGetHeight(frame)-scaledSize.height)/(scaleFactor*2.0))
        scaleTransform     = CGAffineTransformTranslate(scaleTransform, centerOffset.width, centerOffset.height)
        
        if let resultPath = CGPathCreateCopyByTransformingPath(path, &scaleTransform) {
            return resultPath
        }
        
        return path
    }
}