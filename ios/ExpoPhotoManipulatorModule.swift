import ExpoModulesCore
import WCPhotoManipulator

public class ExpoPhotoManipulatorModule: Module {
    typealias LoadImageResult = (Result<UIImage, Error>) -> Void
    internal static let defaultQuality = CGFloat(100)
    
    // Each module class must implement the definition function. The definition consists of components
    // that describes the module's functionality and behavior.
    // See https://docs.expo.dev/modules/module-api for more details about available components.
    public func definition() -> ModuleDefinition {
        // Sets the name of the module that JavaScript code will use to refer to the module. Takes a string as an argument.
        // Can be inferred from module's class name, but it's recommended to set it explicitly for clarity.
        // The module will be accessible from `requireNativeModule('ExpoPhotoManipulator')` in JavaScript.
        Name("ExpoPhotoManipulator")

        // Sets constant properties on the module. Can take a dictionary or a closure that returns a dictionary.
        Constants([:])

        AsyncFunction("batch", batch)
        AsyncFunction("crop", crop)
        AsyncFunction("flipImage", flipImage)
        AsyncFunction("rotateImage", rotateImage)
        AsyncFunction("overlayImage", overlayImage)
        AsyncFunction("printText", printText)
        AsyncFunction("optimize", optimize)
    }
    
    internal func batch(_ url: URL, operations: [[String:Any]], cropRegion: Rect, targetSize: Size?, quality: CGFloat, mimeType: String, promise: Promise) {
        self.loadImage(url) { result in
            switch result {
            case .failure(let error):
                promise.reject(error)
            case .success(let image):
                guard var source = self.cropOrResize(image, cropRegion, targetSize) else {
                    promise.resolve(ImageOperationException())
                    return
                }
                
                for operation in operations {
                    guard let output = self.performOperation(source, operation) else {
                        promise.resolve(ImageOperationException())
                        return
                    }
                    source = output
                }
                
                self.saveFile(source, mimeType: mimeType, quality: ExpoPhotoManipulatorModule.defaultQuality, promise: promise)
            }
        }
    }
    
    private func performOperation(_ image: UIImage, _ operation: [String:Any]) -> UIImage? {
        guard let type = operation["operation"] as? String else {
            return image
        }
        switch type {
        case "text":
            guard let text = ParamUtils.textOptions(operation["options"]) else {
                return image
            }
            return image.drawText(text.text, position: text.getPosition(), style: text.getTextStyle())
        case "flip":
                return image.flip(ParamUtils.flipMode(operation["mode"]))
        case "rotate":
            return image.rotate(ParamUtils.rotationMode(operation["mode"]))
        case "overlay":
            guard let url = ParamUtils.url(operation["overlay"]) else {
                return image
            }
            guard let overlay = ImageUtils.imageFromUrl(url) else {
                return image
            }
            guard let position = ParamUtils.point(operation["position"]) else {
                return image
            }
            
            return image.overlayImage(overlay, position: position.toPoint())
        default:
            return image
        }
    }
    
    internal func crop(_ url: URL, cropRegion: Rect, targetSize: Size?, mimeType: String, promise: Promise) {
        self.loadImage(url) { result in
            switch result {
            case .failure(let error):
                promise.reject(error)
            case .success(let image):
                guard let result = self.cropOrResize(image, cropRegion, targetSize) else {
                    promise.resolve(ImageOperationException())
                    return
                }

                self.saveFile(result, mimeType: mimeType, quality: ExpoPhotoManipulatorModule.defaultQuality, promise: promise)
            }
        }
    }
    
    private func cropOrResize(_ image: UIImage, _ cropRegion: Rect, _ targetSize: Size?) -> UIImage? {
        guard let targetSize = targetSize else {
            return image.crop(cropRegion.toCGRect())
        }
        return image.crop(cropRegion.toCGRect(), targetSize: targetSize.toCGSize())
    }
    
    internal func flipImage(_ url: URL, flipMode: String, mimeType: String, promise: Promise) {
        self.loadImage(url) { result in
            switch result {
            case .failure(let error):
                promise.reject(error)
            case .success(let image):
                let result = image.flip(ParamUtils.flipMode(flipMode))

                self.saveFile(result, mimeType: mimeType, quality: ExpoPhotoManipulatorModule.defaultQuality, promise: promise)
            }
        }
    }
    
    internal func rotateImage(_ url: URL, rotationMode: String, mimeType: String, promise: Promise) {
        self.loadImage(url) { result in
            switch result {
            case .failure(let error):
                promise.reject(error)
            case .success(let image):
                let result = image.rotate(ParamUtils.rotationMode(rotationMode))

                self.saveFile(result, mimeType: mimeType, quality: ExpoPhotoManipulatorModule.defaultQuality, promise: promise)
            }
        }
    }
    
    internal func overlayImage(_ url: URL, overlay: URL, position: Point, mimeType: String, promise: Promise) {
        self.loadImage(url) { result in
            switch result {
            case .failure(let error):
                promise.reject(error)
            case .success(let image):
                self.loadImage(overlay) { result in
                    switch result {
                    case .failure(let error):
                        promise.reject(error)
                    case .success(let icon):
                        guard let output = image.overlayImage(icon, position: position.toPoint()) else {
                            promise.resolve(ImageOperationException())
                            return
                        }

                        self.saveFile(output, mimeType: mimeType, quality: ExpoPhotoManipulatorModule.defaultQuality, promise: promise)
                    }
                }
            }
        }
    }
    
    internal func printText(_ url: URL, texts: [TextOptions], mimeType: String, promise: Promise) {
        self.loadImage(url) { result in
            switch result {
            case .failure(let error):
                promise.reject(error)
            case .success(var image):
                for option in texts {
                    let text = option.text
                    let position = option.getPosition()
                    let style = option.getTextStyle()

                    guard let result = image.drawText(text, position: position, style: style) else {
                        promise.resolve(ImageOperationException())
                        return
                    }
                    image = result
                }

                self.saveFile(image, mimeType: mimeType, quality: ExpoPhotoManipulatorModule.defaultQuality, promise: promise)
            }
        }
    }

    internal func optimize(_ url: URL, quality: CGFloat, promise: Promise) {
        self.loadImage(url) { result in
            switch result {
            case .failure(let error):
                promise.reject(error)
            case .success(let image):
                self.saveFile(image, mimeType: MimeUtils.JPEG, quality: quality, promise: promise)
            }
        }
    }
    
    internal func loadImage(_ url: URL, callback: @escaping LoadImageResult) {
        guard let image = ImageUtils.imageFromUrl(url) else {
            callback(.failure(ImageNotFoundException()))
            return
        }
        callback(.success(image))
    }
    
    internal func saveFile(_ image: UIImage, mimeType: String, quality: CGFloat, promise: Promise) {
        guard let output = ImageUtils.saveTempFile(image, mimeType: mimeType, quality: quality) else {
            promise.reject(SaveFileException())
            return
        }
    
        promise.resolve(output)
    }
}

