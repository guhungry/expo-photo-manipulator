//
//  Exceptions.swift
//  ExpoPhotoManipulator
//
//  Created by Woraphot Chokratanasombat on 9/8/2567 BE.
//

import ExpoModulesCore

internal class ImageNotFoundException: Exception {
    override var reason: String {
        "Image cannot be found"
    }
}

internal class SaveFileException: Exception {
    override var reason: String {
        "File cannot be saved"
    }
}

internal class ImageOperationException: Exception {
    override var reason: String {
        "Cannot perform operation on image"
    }
}


