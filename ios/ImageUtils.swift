//
//  ImageUtils.swift
//  ExpoPhotoManipulator
//
//  Created by Woraphot Chokratanasombat on 9/8/2567 BE.
//

import CoreGraphics
import WCPhotoManipulator

class ImageUtils: NSObject {
    public class func imageFromUrl(_ url: URL) -> UIImage? {
        return FileUtils.imageFromUrl(url)
    }

    public class func saveTempFile(_ image: UIImage, mimeType: String, quality: CGFloat) -> String? {
        let file = FileUtils.createTempFile("", mimeType: mimeType)
        
        FileUtils.saveImageFile(image, mimeType: mimeType, quality: quality, file: file)
        
        return URL.init(string: file)?.absoluteString
    }
}
