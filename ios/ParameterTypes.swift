//
//  ParameterTypes.swift
//  ExpoPhotoManipulator
//
//  Created by Woraphot Chokratanasombat on 9/8/2567 BE.
//

import CoreGraphics
import ExpoModulesCore
import WCPhotoManipulator

internal struct Point: Record {
    @Field
    var x: Double

    @Field
    var y: Double
    
    func toPoint() -> CGPoint {
        return CGPointMake(x, y)
    }
    
    static func from (_ x: Double, _ y: Double) -> Point {
        let result = Point()
        result.x = x
        result.y = y
        return result
    }
}

internal struct Size: Record {
    @Field
    var width: Double

    @Field
    var height: Double
    
    func toCGSize() -> CGSize {
        return CGSizeMake(width, height)
    }
}

internal struct Color: Record {
    /***
     * Red
     */
    @Field
    var r: Double
    
    /***
     * Green
     */
    @Field
    var g: Double
    
    /***
     * Blue
     */
    @Field
    var b: Double
    
    /***
     * Alpha
     */
    @Field
    var a: Double
    
    func toUIColor() -> UIColor {
        return UIColor(red: component(r), green: component(g), blue: component(b), alpha: component(a))
    }
    
    private func component(_ value: Double) -> Double {
        return value / 255
    }
    
    static func from (_ r: Double, _ g: Double, _ b: Double, _ a: Double) -> Color {
        let result = Color()
        result.r = r
        result.g = g
        result.b = b
        result.a = a
        return result
    }
}

internal struct Rect: Record {
    @Field
    var x: Double

    @Field
    var y: Double
    
    @Field
    var width: Double

    @Field
    var height: Double
    
    func toCGRect() -> CGRect {
        return CGRectMake(x, y, width, height)
    }
}

internal struct TextOptions: Record {
    @Field
    var position: Point
    
    @Field
    var text: String
    
    @Field
    var textSize: Double
    
    @Field
    var fontName: String?
    
    @Field
    var color: Color
    
    @Field
    var thickness: Double
    
    @Field
    var rotation: Double
    
    @Field
    var shadowRadius: Double

    @Field
    var shadowOffset: Point?
    
    @Field
    var shadowColor: Color?
    
    func getPosition() -> CGPoint {
        return position.toPoint()
    }
    
    func getTextStyle() -> TextStyle {
        return TextStyle(
                color: color.toUIColor(),
                font: ParamUtils.font(fontName, size: textSize),
                thickness: thickness,
                rotation: rotation,
                shadowRadius: shadowRadius,
                shadowOffsetX: toInt(shadowOffset?.x, 0),
                shadowOffsetY: toInt(shadowOffset?.y, 0),
                shadowColor: shadowColor?.toUIColor()
        )
    }
    
    private func toInt(_ value: Double?, _ defaultValue: Int) -> Int {
        return value.map { Int($0) } ?? defaultValue
    }
}

