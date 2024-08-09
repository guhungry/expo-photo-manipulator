package com.guhungry.expophotomanipulator

import android.graphics.Color as AColor
import android.graphics.PointF
import com.guhungry.photomanipulator.model.CGRect
import com.guhungry.photomanipulator.model.CGSize
import expo.modules.kotlin.records.Field
import expo.modules.kotlin.records.Record

class Point(
    @Field val x: Float = 0f,
    @Field val y: Float = 0f
): Record {
    fun toPointF(): PointF {
        return PointF(x, y)
    }
}

class Size: Record {
    @Field
    val width: Int = 0

    @Field
    val height: Int = 0

    fun toCGSize(): CGSize {
        return CGSize(width, height)
    }
}

class Color(
    // Red
    @Field val r: Int = 0,

    // Green
    @Field val g: Int = 0,

    // Blue
    @Field val b: Int = 0,
        // Alpha
    @Field val a: Int = 0
): Record {
    fun toColor() = AColor.argb(a, r, g, b)
}

class Rect: Record {
    @Field
    val x: Int = 0

    @Field
    val y: Int = 0

    @Field
    val width: Int = 0

    @Field
    val height: Int = 0

    fun toCGRect(): CGRect {
        return CGRect(x, y, width, height)
    }

}

class TextOptions(
    @Field
    val position: Point = Point(),

    @Field
    val text: String = "",

    @Field
    val textSize: Float = 0f,

    @Field
    val fontName: String? = null,

    @Field
    val color: Color = Color(),

    @Field
    val thickness: Float = 0f,

    @Field
    val rotation: Float = 0f,

    @Field
    val shadowRadius: Float = 0f,

    @Field
    val shadowOffset: Point? = null,

    @Field
    val shadowColor: Color? = null
) : Record