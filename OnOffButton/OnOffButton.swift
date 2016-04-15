import UIKit

@IBDesignable
class OnOffButton: UIButton {
    
    // MARK: Inspectables
    
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
    
    // MARK: Variables
    
    var checked: Bool = true {
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateProperties()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateProperties()
    }
    
    private func updateProperties() {
        createLayersIfNeeded()
        if onOffLayer != nil {
            onOffLayer.lineWidth = lineWidth
            onOffLayer.strokeColor = strokeColor.CGColor
        }
        
        if ringLayer != nil {
            ringLayer.lineWidth = lineWidth
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