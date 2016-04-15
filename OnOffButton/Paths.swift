import UIKit

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
