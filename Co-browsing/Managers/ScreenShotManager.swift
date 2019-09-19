//
//  ScreenShotManager.swift
//  Co-browsing
//
//  Created by Артем Бурдейный on 16/09/2019.
//  Copyright © 2019 Артем Бурдейный. All rights reserved.
//

import UIKit

class ScreenShotManager {
    
    static let shared = ScreenShotManager()
    
    private let imageScale: CGFloat = 0.5
    
    internal func takeScreenShot() -> UIImage? {
        var screenshotImage: UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let image = screenshotImage else { return nil }
        let targetWidth = image.size.width * imageScale
        let targetHeight = image.size.height * imageScale
        let targetSize = CGSize(width: targetWidth, height: targetHeight)
        let resizedImage = resizeImage(image: image, targetSize: targetSize)
        
        return resizedImage
    }
    
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
