//
//  UIImage+EMUtils.swift
//  EMUtils
//
//  Created by Ewan Mellor on 5/7/17.
//  Copyright © 2017 Ewan Mellor. All rights reserved.
//

import UIKit


extension UIImage {
    /**
     - Returns: A copy of this image, scaled to the specified max in the
     larger dimension while preserving the aspect ratio.
     */
    public func scaledPreservingAspect(maxSize: CGFloat) -> UIImage {
        let scaledSize = scaledSizeForMax(maxSize)

        UIGraphicsBeginImageContext(scaledSize)
        draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return result
    }

    private func scaledSizeForMax(_ maxSize: CGFloat) -> CGSize {
        let width = size.width
        let height = size.height

        if width == height {
            return CGSize(width: maxSize, height: maxSize)
        }
        else if width > height {
            return CGSize(width: maxSize, height: maxSize * height / width)
        }
        else {
            return CGSize(width: maxSize * width / height, height: maxSize)
        }
    }

    /**
     - Returns: A copy of this image, rotated by the specified angle in
     degrees.
     */
    public func rotated(degrees: CGFloat) -> UIImage {
        let radians = degreesToRadians(degrees)
        return rotated(radians: radians)
    }

    /**
     - Returns: A copy of this image, rotated by the specified angle in
     radians.
     */
    public func rotated(radians: CGFloat) -> UIImage {
        let rotatedViewBox = UIView(frame: CGRect(origin: .zero, size: size))
        let t = CGAffineTransform(rotationAngle: radians)
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size

        UIGraphicsBeginImageContext(rotatedSize)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0)
        ctx.rotate(by: radians)
        ctx.scaleBy(x: 1.0, y: -1.0)
        ctx.draw(cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result!
    }


    public class func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result
    }
}


fileprivate func degreesToRadians(_ deg: CGFloat) -> CGFloat {
    return deg / 180.0 * .pi
}
