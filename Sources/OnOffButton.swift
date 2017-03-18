import UIKit

@IBDesignable
open class OnOffButton: UIButton {

    // MARK: Inspectables

    @IBInspectable open var lineWidth: CGFloat = 1 {
        didSet {
            updateProperties()
        }
    }

    @IBInspectable open var strokeColor: UIColor = UIColor.white {
        didSet {
            updateProperties()
        }
    }

    @IBInspectable open var ringAlpha: CGFloat = 0.5 {
        didSet {
            updateProperties()
        }
    }

    // MARK: Variables

    open var checked: Bool = true {
        didSet {
            var strokeStart = CABasicAnimation()
            var strokeEnd = CABasicAnimation()
            if checked {
                let animations = checkedAnimation()
                strokeStart    = animations.strokeStart
                strokeEnd      = animations.strokeEnd
            } else {
                let animations = unchekedAnimation()
                strokeStart    = animations.strokeStart
                strokeEnd      = animations.strokeEnd
            }
            onOffLayer.applyAnimation(strokeStart)
            onOffLayer.applyAnimation(strokeEnd)
        }
    }

    fileprivate var onOffLayer: CAShapeLayer!
    fileprivate var ringLayer: CAShapeLayer!
    fileprivate let onStrokeStart: CGFloat  = 0.025
    fileprivate let onStrokeEnd: CGFloat    = 0.20
    fileprivate let offStrokeStart: CGFloat = 0.268
    fileprivate let offStrokeEnd: CGFloat   = 1.0
    fileprivate let miterLimit: CGFloat     = 10

    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        updateProperties()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateProperties()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        updateProperties()
    }

    // MARK: Layout
    fileprivate func updateProperties() {
        // using init() will raise CGPostError, lets prevent it
        if bounds == CGRect.zero { return }

        createLayersIfNeeded()
        if onOffLayer != nil {
            onOffLayer.lineWidth   = lineWidth
            onOffLayer.strokeColor = strokeColor.cgColor
        }

        if ringLayer != nil {
            ringLayer.lineWidth   = lineWidth
            ringLayer.strokeColor = ringColorWithAlpha()
        }
    }

    // MARK: Layer Set Up

    fileprivate func createLayersIfNeeded() {
        if onOffLayer == nil {
            onOffLayer = createOnOffLayer()
            layer.addSublayer(onOffLayer)
        }

        if ringLayer == nil {
            ringLayer = createRingLayer()
            layer.addSublayer(ringLayer)
        }
    }

    fileprivate func createOnOffLayer() -> CAShapeLayer {
        let onOffLayer = CAShapeLayer()
        onOffLayer.path = CGPath.rescaleForFrame(OnOff.innerPath, frame: self.bounds)

        let strokingPath       = onOffLayer.path?.copy(strokingWithWidth: lineWidth,
                                                       lineCap: .round,
                                                       lineJoin: .miter,
                                                       miterLimit: miterLimit)

        onOffLayer.bounds      = strokingPath!.boundingBoxOfPath
        onOffLayer.position    = CGPoint(x: onOffLayer.bounds.midX, y: onOffLayer.bounds.midY)
        onOffLayer.strokeStart = onStrokeStart
        onOffLayer.strokeEnd   = onStrokeEnd
        onOffLayer.strokeColor = strokeColor.cgColor
        setUpShapeLayer(onOffLayer)

        return onOffLayer
    }

    fileprivate func createRingLayer() -> CAShapeLayer {
        let ringLayer = CAShapeLayer()
        let boundsWithInsets  = onOffLayer.bounds.insetBy(dx: lineWidth/2, dy: lineWidth/2)
        let ovalPath          = OnOff.ringPathForFrame(boundsWithInsets)
        ringLayer.path        = ovalPath
        ringLayer.bounds      = onOffLayer.bounds
        ringLayer.position    = onOffLayer.position
        ringLayer.strokeColor = ringColorWithAlpha()
        setUpShapeLayer(ringLayer)

        return ringLayer
    }

    fileprivate func setUpShapeLayer(_ shapeLayer: CAShapeLayer) {
        shapeLayer.fillColor     = nil
        shapeLayer.lineWidth     = lineWidth
        shapeLayer.miterLimit    = miterLimit
        shapeLayer.lineCap       = kCALineCapRound
        shapeLayer.masksToBounds = false
    }

    fileprivate func ringColorWithAlpha() -> CGColor {
        return strokeColor.withAlphaComponent(ringAlpha).cgColor
    }

    // MARK: Animations

    fileprivate func checkedAnimation() -> (strokeStart: CABasicAnimation, strokeEnd: CABasicAnimation) {
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

    fileprivate func unchekedAnimation() -> (strokeStart: CABasicAnimation, strokeEnd: CABasicAnimation) {
        let strokeStart = CABasicAnimation(keyPath: "strokeStart")
        strokeStart.toValue  = offStrokeStart
        strokeStart.duration = 0.6
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
        let path = CGMutablePath()
        path.move(to: CGPoint(x:60.48, y:17.5))
        path.addLine(to: CGPoint(x:31.63, y:46.34))
        path.addLine(to: CGPoint(x:5.05, y:19.76))
        path.addCurve(to: CGPoint(x:52.15, y:4.44),
                      control1: CGPoint(x:13.84, y:2.51),
                      control2: CGPoint(x:34.92, y:-4.33))
        path.addCurve(to: CGPoint(x:67.44, y:51.53),
                      control1: CGPoint(x:69.37, y:13.22),
                      control2: CGPoint(x:76.22, y:34.3))
        path.addCurve(to: CGPoint(x:20.36, y:66.82),
                      control1: CGPoint(x:58.67, y:68.75),
                      control2: CGPoint(x:37.59, y:75.6))
        path.addCurve(to: CGPoint(x:5.07, y:19.74),
                      control1: CGPoint(x:3.14, y:58.05),
                      control2: CGPoint(x:-3.71, y:36.97))

        return path
    }

    static func ringPathForFrame(_ frame: CGRect) -> CGPath {
        let outerPath = UIBezierPath(ovalIn: frame)
        return outerPath.cgPath
    }
}

// MARK: Extensions

extension CALayer {
    func applyAnimation(_ animation: CABasicAnimation) {
        let copy = animation.copy() as? CABasicAnimation ?? CABasicAnimation()
        if  copy.fromValue == nil,
            let presentationLayer = presentation() {
            copy.fromValue = presentationLayer.value(forKeyPath: copy.keyPath ?? "")
        }
        add(copy, forKey: copy.keyPath)
        performWithoutAnimation {
            self.setValue(copy.toValue, forKeyPath:copy.keyPath ??  "")
        }
    }

    func performWithoutAnimation(_ closure: (Void) -> Void) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        closure()
        CATransaction.commit()
    }
}

extension CGPath {
    //scaling :http://www.google.com/url?q=http%3A%2F%2Fstackoverflow.com%2Fquestions%2F15643626%2Fscale-cgpath-to-fit-uiview&sa=D&sntz=1&usg=AFQjCNGKPDZfy0-_lkrj3IfWrTGp96QIFQ
    //nice answer from David Rönnqvist!
    class func rescaleForFrame(_ path: CGPath, frame: CGRect) -> CGPath {
        let boundingBox            = path.boundingBoxOfPath
        let boundingBoxAspectRatio = boundingBox.width/boundingBox.height
        let viewAspectRatio        = frame.width/frame.height

        var scaleFactor: CGFloat = 1.0
        if boundingBoxAspectRatio > viewAspectRatio {
            scaleFactor = frame.width/boundingBox.width
        } else {
            scaleFactor = frame.height/boundingBox.height
        }

        var scaleTransform = CGAffineTransform.identity
        scaleTransform     = scaleTransform.scaledBy(x: scaleFactor, y: scaleFactor)
        scaleTransform     = scaleTransform.translatedBy(x: -boundingBox.minX, y: -boundingBox.minY)
        let scaledSize     = boundingBox.size.applying(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
        let centerOffset   = CGSize(width:(frame.width - scaledSize.width) / (scaleFactor * 2.0),
                                    height:(frame.height - scaledSize.height) / (scaleFactor * 2.0))
        scaleTransform     = scaleTransform.translatedBy(x: centerOffset.width, y: centerOffset.height)

        if let resultPath = path.copy(using: &scaleTransform) {
            return resultPath
        }

        return path
    }
}
