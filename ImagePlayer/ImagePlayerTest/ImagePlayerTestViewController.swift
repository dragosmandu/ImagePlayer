//
//
//  Workspace: ImagePlayer
//  MacOS Version: 11.4
//			
//  File Name: ImagePlayerTestViewController.swift
//  Creation: 5/31/21 8:26 PM
//
//  Author: Dragos-Costin Mandu
//
//


import UIKit
import ImagePlayer

class ImagePlayerTestViewController: UIViewController
{
    private var m_AnimatedImageUrl = URL(string: "https://media.giphy.com/media/LXH6tT5Q6MDFBRjYaC/giphy.gif")!
    private var m_ImagePlayer: ImagePlayerViewController = .init(imageUrl: nil, isAnimatingImage: true)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        m_ImagePlayer.view.translatesAutoresizingMaskIntoConstraints = false
        m_ImagePlayer.updateContentModeWith(newContentMode: .scaleAspectFit)
        
        addChild(m_ImagePlayer)
        view.addSubview(m_ImagePlayer.view)
        
        NSLayoutConstraint.activate(
            [
                m_ImagePlayer.view.widthAnchor.constraint(equalTo: view.widthAnchor),
                m_ImagePlayer.view.heightAnchor.constraint(equalTo: view.heightAnchor)
            ]
        )
        
        m_ImagePlayer.updateImageFor(newImageUrl: m_AnimatedImageUrl)
    }
}

