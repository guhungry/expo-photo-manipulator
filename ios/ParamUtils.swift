//
//  ParamUtils.swift
//  ExpoPhotoManipulator
//
//  Created by Woraphot Chokratanasombat on 9/8/2567 BE.
//

import CoreGraphics
import WCPhotoManipulator

class ParamUtils: NSObject {
    public class func url(_ value: Any?) -> URL? {
        guard let value = value as? String else {
            return nil
        }
        return URL(string: value)
    }
    
    public class func font(_ name: String?, size: CGFloat) -> UIFont {
        guard let name = name else {
            return UIFont.systemFont(ofSize: size)
        }
        return UIFont(name: name, size: size)
            ?? UIFont.systemFont(ofSize: size)
    }

    public class func textOptions(_ values: Any?) -> TextOptions? {
        guard let values = values as? Dictionary<String, Any> else {
            return nil
        }
        guard let position = self.point(values["position"]),
              let text = values["text"] as? String,
              let textSize = values["textSize"] as? Double,
              let color = self.color(values["color"]),
              let thickness = values["thickness"] as? Double,
              let rotation = values["rotation"] as? Double,
              let shadowRadius = values["shadowRadius"] as? Double else {
            return nil
        }
        let result = TextOptions()
        result.position = position
        result.text = text
        result.textSize = textSize
        result.fontName = values["fontName"] as? String
        result.color = color
        result.thickness = thickness
        result.rotation = rotation
        result.shadowRadius = shadowRadius
        result.shadowOffset = self.point(values["shadowOffset"])
        result.shadowColor = self.color(values["shadowColor"])
        return result
    }
    
    public class func point(_ values: Any?) -> Point? {
        guard let values = values as? Dictionary<String, Any> else {
            return nil
        }
        guard let x = values["x"] as? Double,
              let y = values["y"] as? Double else {
            return nil
        }
        return Point.from(x, y)
    }
    
    public class func color(_ values: Any?) -> Color? {
        guard let values = values as? Dictionary<String, Any> else {
            return nil
        }
        guard let r = values["r"] as? Double,
              let g = values["g"] as? Double,
              let b = values["b"] as? Double,
              let a = values["a"] as? Double else {
            return nil
        }
        return Color.from(r, g, b, a)
    }

    public class func flipMode(_ mode: Any?) -> FlipMode {
        guard let mode = mode as? String else {
            return .None
        }
        switch mode.lowercased() {
        case "both":
            return .Both
        case "vertical":
            return .Vertical
        case "horizontal":
            return .Horizontal
        default:
            return .None
        }
    }
    
    public class func rotationMode(_ mode: Any?) -> RotationMode {
        guard let mode = mode as? String else {
            return .None
        }
        switch mode.lowercased() {
        case "r90":
            return .R90
        case "r180":
            return .R180
        case "r270":
            return .R270
        default:
            return .None
        }
    }
}
