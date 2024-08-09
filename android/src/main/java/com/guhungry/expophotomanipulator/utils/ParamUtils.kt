package com.guhungry.expophotomanipulator.utils

import android.graphics.PointF
import com.guhungry.expophotomanipulator.Color
import com.guhungry.expophotomanipulator.Point
import com.guhungry.expophotomanipulator.TextOptions
import com.guhungry.photomanipulator.model.FlipMode
import com.guhungry.photomanipulator.model.RotationMode

/**
 * Parameter Utilities for Convert JS Parameter to Native Java
 */
object ParamUtils {
    // PointF
    @JvmStatic fun pointF(map: Map<String, Any>?): PointF? = map?.let { pointF(it["x"] as Number, it["y"] as Number) }
    @JvmStatic fun pointF(x: Number, y: Number): PointF = PointF(x.toFloat(), y.toFloat())

    // Color
    private fun color(color: Map<String, Any>?) = color?.let {
        Color(
            (color["r"] as Number).toInt(),
            (color["g"] as Number).toInt(),
            (color["b"] as Number).toInt(),
            (color["a"] as Number).toInt()
        )
    }

    // FlipMode
    @JvmStatic fun flipMode(mode: String): FlipMode = runCatching { FlipMode.valueOf(mode) }.getOrDefault(FlipMode.None)

    // FlipMode
    @JvmStatic fun rotationMode(mode: String): RotationMode = runCatching { RotationMode.valueOf(mode) }.getOrDefault(RotationMode.None)

    // TextOptions
    @JvmStatic
    fun textOptions(map: Map<String, Any>): TextOptions {
        return TextOptions(
            text = map["text"] as String,
            position = point(map["position"] as Map<String, Any>)!!,
            textSize = float(map["textSize"])!!,
            fontName = map["fontName"] as String?,
            color = color(map["color"] as Map<String, Any>)!!,
            thickness = float(map["thickness"])!!,
            rotation = float(map["rotation"])!!,
            shadowRadius = float(map["shadowRadius"])!!,
            shadowOffset = point(map["shadowOffset"] as Map<String, Any>?),
            shadowColor = color(map["shadowColor"] as Map<String, Any>?)
        )
    }

    private fun float(value: Any?) = (value as Number?)?.toFloat()

    private fun point(position: Map<String, Any>?) = position?.let {
        Point((it["x"] as Number).toFloat(), (it["y"] as Number).toFloat())
    }
}