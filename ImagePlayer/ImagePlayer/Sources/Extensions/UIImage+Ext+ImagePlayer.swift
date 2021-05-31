//
//
//  Workspace: ImagePlayer
//  MacOS Version: 11.4
//			
//  File Name: UIImage+Ext+ImagePlayer.swift
//  Creation: 5/31/21 8:15 PM
//
//  Author: Dragos-Costin Mandu
//
//


import SwiftUI
import AVFoundation
import MobileCoreServices
import os

public extension UIImage
{
    // MARK: - Constants & Variables
    static var s_LoggerCategory: String = "UIImage"
    static var s_Logger: Logger = .init(subsystem: loggerSubsystem, category: s_LoggerCategory)
    
    static var s_AnimatedImageDefaultInterFrameDelay: Double = 0.1
    static var s_AnimatedImageDefaultLoopCount: Int = 0
}

public extension UIImage
{
    // MARK: - Animated Image
    
    /// Creates an animated image from given CGImageSource.
    /// - Parameters:
    ///   - frameMaxPixelSize: The maximum width and height in pixels of a thumbnail.
    ///   - frameCompresionQuality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality).
    ///   - interFrameDelay: The delay between 2 frames. Set only when the animated image Data doesn't have a delay already.
    static func animatedImageWith(imageSource: CGImageSource, frameMaxPixelSize: CGFloat? = nil, frameCompresionQuality: CGFloat = 1, interFrameDelay: Double = UIImage.s_AnimatedImageDefaultInterFrameDelay) -> UIImage?
    {
        let count = CGImageSourceGetCount(imageSource)
        var delay = interFrameDelay
        
        if let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary?
        {
            if let delayTime = properties[kCGImagePropertyGIFDictionary as NSString]?[kCGImagePropertyGIFDelayTime as NSString]
            {
                if let delayTime = delayTime as? NSNumber
                {
                    delay = Double(truncating: delayTime)
                }
            }
        }
        
        var frames = [UIImage]()
        let duration = Double(count) * delay
        
        for index in 0..<count
        {
            if let cgImage = imageSource.downsample(thumbnailMaxPixelSize: frameMaxPixelSize, imageIndex: index)
            {
                var uiImage = UIImage(cgImage: cgImage)
                
                if frameCompresionQuality < 1, let compressedUIImageData = uiImage.jpegData(compressionQuality: frameCompresionQuality), let compressedUIImage = UIImage(data: compressedUIImageData)
                {
                    uiImage = compressedUIImage
                }
                
                frames.append(uiImage)
            }
        }
        
        let animatedImage = UIImage.animatedImage(with: frames, duration: duration)
        
        return animatedImage
    }
    
    /// Creates an animated image from given Data.
    /// - Parameters:
    ///   - frameMaxPixelSize: The maximum width and height in pixels of a thumbnail.
    ///   - frameCompresionQuality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality).
    ///   - interFrameDelay: The delay between 2 frames. Set only when the animated image Data doesn't have a delay already.
    static func animatedImageWith(data: Data, frameMaxPixelSize: CGFloat? = nil, frameCompresionQuality: CGFloat = 1, interFrameDelay: Double = UIImage.s_AnimatedImageDefaultInterFrameDelay) -> UIImage?
    {
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil)
        else
        {
            UIImage.s_Logger.error("Failed to create image source with data '\(data.count).'")
            
            return nil
        }
        
        return animatedImageWith(imageSource: imageSource, frameMaxPixelSize: frameMaxPixelSize, frameCompresionQuality: frameCompresionQuality, interFrameDelay: interFrameDelay)
    }
}

