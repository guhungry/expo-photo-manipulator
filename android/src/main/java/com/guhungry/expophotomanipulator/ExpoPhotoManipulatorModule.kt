package com.guhungry.expophotomanipulator

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Paint
import android.graphics.Typeface
import com.facebook.react.common.assets.ReactFontManager
import com.guhungry.expophotomanipulator.utils.ImageUtils.bitmapFromUri
import com.guhungry.expophotomanipulator.utils.ImageUtils.cropBitmapFromUri
import com.guhungry.expophotomanipulator.utils.ImageUtils.mutableOptions
import com.guhungry.expophotomanipulator.utils.ImageUtils.saveTempFile
import com.guhungry.expophotomanipulator.utils.ParamUtils
import com.guhungry.expophotomanipulator.utils.ParamUtils.flipMode
import com.guhungry.expophotomanipulator.utils.ParamUtils.pointF
import com.guhungry.expophotomanipulator.utils.ParamUtils.rotationMode
import com.guhungry.expophotomanipulator.utils.ParamUtils.textOptions
import com.guhungry.photomanipulator.BitmapUtils.flip
import com.guhungry.photomanipulator.BitmapUtils.overlay
import com.guhungry.photomanipulator.BitmapUtils.printText
import com.guhungry.photomanipulator.BitmapUtils.rotate
import com.guhungry.photomanipulator.MimeUtils
import com.guhungry.photomanipulator.model.TextStyle
import expo.modules.kotlin.Promise
import expo.modules.kotlin.exception.CodedException
import expo.modules.kotlin.exception.Exceptions
import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition


class ExpoPhotoManipulatorModule : Module() {
  private val context: Context
    get() = appContext.reactContext ?: throw Exceptions.ReactContextLost()

  override fun definition() = ModuleDefinition {
    Name("ExpoPhotoManipulator")

    Constants()

    AsyncFunction("batch") { uri: String, operations: List<Map<String, Any>>, cropRegion: Rect, targetSize: Size?, quality: Double?, mimeType: String?, promise: Promise ->
      try {
        var output = cropBitmapFromUri(context, uri, cropRegion.toCGRect(), targetSize?.toCGSize())

        // Operations
        for (operation in operations) {
          output = processBatchOperation(output, operation)
        }

        // Save & Optimize
        val file = saveTempFile(context, output, mimeType!!, FILE_PREFIX, quality!!.toInt())
        output.recycle()

        promise.resolve(file)
      } catch (e: Exception) {
        promise.reject(CodedException(e))
      }
    }

    AsyncFunction("crop") { uri: String, cropRegion: Rect, targetSize: Size?, mimeType: String?, promise: Promise ->
      try {
        val output = cropBitmapFromUri(context, uri, cropRegion.toCGRect(), targetSize?.toCGSize())

        val file = saveTempFile(context, output, mimeType!!, FILE_PREFIX, DEFAULT_QUALITY)
        output.recycle()

        promise.resolve(file)
      } catch (e: Exception) {
        promise.reject(CodedException(e))
      }
    }

    AsyncFunction("flipImage") { uri: String, mode: String, mimeType: String?, promise: Promise ->
      try {
        val input = bitmapFromUri(context, uri, mutableOptions())

        val output = flip(input, flipMode(mode))
        input.recycle()

        val file = saveTempFile(context, output, mimeType!!, FILE_PREFIX, DEFAULT_QUALITY)
        output.recycle()

        promise.resolve(file)
      } catch (e: Exception) {
        promise.reject(CodedException(e))
      }
    }

    AsyncFunction("rotateImage") { uri: String, mode: String, mimeType: String?, promise: Promise ->
      try {
        val input = bitmapFromUri(context, uri, mutableOptions())

        val output = rotate(input, rotationMode(mode))
        input.recycle()

        val file = saveTempFile(context, output, mimeType!!, FILE_PREFIX, DEFAULT_QUALITY)
        output.recycle()

        promise.resolve(file)
      } catch (e: Exception) {
        promise.reject(CodedException(e))
      }
    }

    AsyncFunction("overlayImage") { uri: String, icon: String, position: Point, mimeType: String?, promise: Promise ->
      try {
        val output = bitmapFromUri(context, uri, mutableOptions())
        val overlay = bitmapFromUri(context, icon)

        overlay(output, overlay, position.toPointF())
        overlay.recycle()

        val file = saveTempFile(context, output, mimeType!!, FILE_PREFIX, DEFAULT_QUALITY)
        output.recycle()

        promise.resolve(file)
      } catch (e: Exception) {
        promise.reject(CodedException(e))
      }
    }

    AsyncFunction("printText") { uri: String, texts: List<TextOptions>, mimeType: String?, promise: Promise ->
      try {
        val output = bitmapFromUri(context, uri, mutableOptions())

        for (text in texts) {
          printLine(output, text)
        }

        val file = saveTempFile(context, output, mimeType!!, FILE_PREFIX, DEFAULT_QUALITY)
        output.recycle()

        promise.resolve(file)
      } catch (e: Exception) {
        promise.reject(CodedException(e))
      }
    }

    AsyncFunction("optimize") { uri: String, quality: Double, promise: Promise ->
      try {
        val output = bitmapFromUri(context, uri)

        val file = saveTempFile(context, output, MimeUtils.JPEG, FILE_PREFIX, quality.toInt())
        output.recycle()

        promise.resolve(file)
      } catch (e: Exception) {
        promise.reject(CodedException(e))
      }
    }
  }

  private fun processBatchOperation(image: Bitmap, operation: Map<String, Any>?): Bitmap {
    if (operation == null) return image
    when (operation["operation"] as? String) {
      "text" -> {
        val text = operation["options"] as? Map<String, Any> ?: return image

        printLine(image, textOptions(text))
        return image
      }

      "overlay" -> {
        val uri = operation["overlay"] as? String ?: return image

        val overlay = bitmapFromUri(context, uri)
        overlay(image, overlay, pointF(operation["position"] as? Map<String, Any>)!!)
        return image
      }

      "flip" -> {
        return flip(image, flipMode(operation["mode"] as String))
      }

      "rotate" -> {
        return rotate(image, rotationMode(operation["mode"] as String))
      }

      else -> return image
    }
  }

  private fun printLine(image: Bitmap, options: TextOptions) {
    val style = TextStyle(
      options.color.toColor(),
      options.textSize,
      getFont(options.fontName),
      Paint.Align.LEFT,
      options.thickness,
      options.rotation,
      options.shadowRadius,
      options.shadowOffset?.x ?: 0f,
      options.shadowOffset?.y ?: 0f,
      options.shadowColor?.toColor()
    )
    printText(image, options.text, options.position.toPointF(), style)
  }

  private fun getFont(fontName: String?): Typeface {
    if (fontName == null) return Typeface.DEFAULT
    return try {
      ReactFontManager.getInstance()
        .getTypeface(fontName, Typeface.NORMAL, context.assets)
    } catch (e: Exception) {
      Typeface.DEFAULT
    }
  }

  companion object {
    private const val FILE_PREFIX = "EPM_"
    private const val DEFAULT_QUALITY = 100
  }
}
