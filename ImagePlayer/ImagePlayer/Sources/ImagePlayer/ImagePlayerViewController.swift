//
//
//  Workspace: ImagePlayer
//  MacOS Version: 11.4
//			
//  File Name: ImagePlayerViewController.swift
//  Creation: 5/31/21 7:57 PM
//
//  Author: Dragos-Costin Mandu
//
//


import UIKit
import os
import DownloadTaskManager

var loggerSubsystem: String = Bundle.main.bundleIdentifier!

public class ImagePlayerViewController: UIViewController
{
    // MARK: - Initialization
    
    public static var s_LoggerCategory: String = "ImagePlayerView"
    public static var s_Logger: Logger = .init(subsystem: loggerSubsystem, category: s_LoggerCategory)
    
    public private(set) var currentImageUrl: URL?
    public private(set) var isDownloading: Bool = false
    
    /// If the image can content mode can be changed with a pinch gesture.
    public var isContentModeGestureToggleable: Bool = true
    public var isAnimatedImage: Bool
    {
        get
        {
            return m_IsAnimatedImage
        }
        set
        {
            m_IsAnimatedImage = newValue
            m_DownloadTaskManager.cancelCurrentDownload() // If any with resume data.
            processCurrentImageUrl() // Reprocess current URL.
        }
    }
    
    open var m_ImageBackgroundColor: UIColor
    {
        let imageBackgroundColor = UIColor.black
        
        return imageBackgroundColor
    }
    
    private var m_ImageView: UIImageView = .init(frame: .zero)
    private var m_DownloadTaskManager: DownloadTaskManager = .init()
    private var m_IsAnimatedImage: Bool
    
    public init(imageUrl: URL?, isAnimatingImage: Bool = false)
    {
        currentImageUrl = imageUrl
        m_IsAnimatedImage = isAnimatingImage
        
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder)
    {
        m_IsAnimatedImage = false
        
        super.init(coder: coder)
    }
}

public extension ImagePlayerViewController
{
    // MARK: - Life Cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        m_DownloadTaskManager.delegate = self
        
        configure()
        processCurrentImageUrl() // Uses the image URL given in init, if any.
        updateColors()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?)
    {
        super.traitCollectionDidChange(previousTraitCollection)
        
        updateColors()
    }
}

public extension ImagePlayerViewController
{
    // MARK: - Updates
    
    func updateImageFor(newImageUrl: URL)
    {
        ImagePlayerViewController.s_Logger.debug("Updating image with '\(newImageUrl.absoluteString)'.")
        
        currentImageUrl = newImageUrl
        processCurrentImageUrl()
    }
    
    func updateImageWith(newImageData: Data)
    {
        ImagePlayerViewController.s_Logger.debug("Updating image with new image data.")
        
        updateImageWith(data: newImageData)
    }
    
    func updateContentModeWith(newContentMode: UIImageView.ContentMode)
    {
        ImagePlayerViewController.s_Logger.debug("Updating image content mode with '\(newContentMode.rawValue)'.")
        
        m_ImageView.contentMode = newContentMode
    }
    
    func toggleContentMode()
    {
        if m_ImageView.contentMode == .scaleAspectFill
        {
            updateContentModeWith(newContentMode: .scaleAspectFit)
        }
        else
        {
            updateContentModeWith(newContentMode: .scaleAspectFill)
        }
    }
}

private extension ImagePlayerViewController
{
    // MARK: Configuration
    
    func configure()
    {
        ImagePlayerViewController.s_Logger.debug("Start configuration.")
        
        configureImageView()
        setGestures()
    }
    
    func configureImageView()
    {
        m_ImageView.translatesAutoresizingMaskIntoConstraints = false
        m_ImageView.contentMode = .scaleAspectFill
        m_ImageView.clipsToBounds = true
        
        updateImageBackgroundColor()
        view.addSubview(m_ImageView)
        
        NSLayoutConstraint.activate(
            [
                m_ImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                m_ImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                m_ImageView.topAnchor.constraint(equalTo: view.topAnchor),
                m_ImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )
    }
    
    func setGestures()
    {
        setContentModeChangeGesture()
    }
    
    func setContentModeChangeGesture()
    {
        view.addContentModeChangeGesture
        { completion in
            if self.m_ImageView.contentMode == .scaleAspectFit || !self.isContentModeGestureToggleable
            {
                completion(false)
            }
            else
            {
                
                // Plays haptic when the content mode changed to a different value.
                self.updateContentModeWith(newContentMode: .scaleAspectFit)
                completion(true)
            }
        }
        changeToAspectFillAction:
        { completion in
            if self.m_ImageView.contentMode == .scaleAspectFill || !self.isContentModeGestureToggleable
            {
                completion(false)
            }
            else
            {
                
                // Plays haptic when the content mode changed to a different value.
                self.updateContentModeWith(newContentMode: .scaleAspectFill)
                completion(true)
            }
        }
    }
}
private extension ImagePlayerViewController
{
    // MARK: - Updates
    
    func updateColors()
    {
        ImagePlayerViewController.s_Logger.debug("Updating colors in view.")
        
        updateImageBackgroundColor()
    }
    
    func updateImageBackgroundColor()
    {
        m_ImageView.backgroundColor = m_ImageBackgroundColor
    }
    
    func updateImageWith(data: Data)
    {
        if m_IsAnimatedImage, let animatedImage = UIImage.animatedImageWith(data: data)
        {
            updateImageWith(newImage: animatedImage)
        }
        else if let image = UIImage(data: data)
        {
            updateImageWith(newImage: image)
        }
        else
        {
            ImagePlayerViewController.s_Logger.error("Failed create image for '\(self.currentImageUrl?.absoluteString ?? "")'.")
        }
    }
    
    func updateImageWith(newImage: UIImage?)
    {
        DispatchQueue.main.async
        {
            self.m_ImageView.image = newImage
            self.m_ImageView.setNeedsDisplay()
        }
    }
    
    func processCurrentImageUrl()
    {
        updateImageWith(newImage: nil) // Removing previous image, if any.
        isDownloading = true
        
        guard let currentImageUrl = currentImageUrl
        else
        {
            return
        }
        
        if currentImageUrl.isFileURL, let data = try? Data(contentsOf: currentImageUrl)
        {
            updateImageWith(data: data)
            isDownloading = false
        }
        else
        {
            m_DownloadTaskManager.downloadFor(externalUrl: currentImageUrl)
        }
    }
}

extension ImagePlayerViewController: DownloadTaskDelegate
{
    // MARK: TCKitDownloadTaskDelegate
    
    public func didChangeDownloadProgress(_ downloadTaskManager: DownloadTaskManager, newDownloadProgress: Double)
    {
        
    }
    
    public func didFinishDownload(_ downloadTaskManager: DownloadTaskManager, success: Bool)
    {
        defer { isDownloading = false }
        
        if success, let imageFileUrl = downloadTaskManager.currentFileUrl, let data = try? Data(contentsOf: imageFileUrl)
        {
            ImagePlayerViewController.s_Logger.debug("Successfully downloaded image for '\(self.currentImageUrl?.absoluteString ?? "")'.")
            
            updateImageWith(data: data)
        }
        else
        {
            ImagePlayerViewController.s_Logger.error("Failed to download image for '\(self.currentImageUrl?.absoluteString ?? "")'.")
        }
    }
}

