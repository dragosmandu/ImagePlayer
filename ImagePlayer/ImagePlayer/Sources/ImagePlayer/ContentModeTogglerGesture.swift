//
// 
//  Workspace: ImagePlayer
//  MacOS Version: 11.4
//			
//  File Name: ContentModeTogglerGesture.swift
//  Creation: 5/31/21 8:07 PM
//
//  Author: Dragos-Costin Mandu
//
//


import UIKit
import os
import CoreHaptics

class ContentModeChangeGesture: UIPinchGestureRecognizer
{
    public static var s_LoggerCategory: String = "ContentModeChangeGesture"
    public static var s_Logger: Logger = .init(subsystem: loggerSubsystem, category: s_LoggerCategory)
    public static var s_GestureName: String = "ContentModeChangeGestureName"
    
    private let m_ChangeToAspectFitAction: ((_ playHaptic: Bool) -> Void) -> Void
    private let m_ChangeToAspectFillAction: ((_ playHaptic: Bool) -> Void) -> Void
    
    public init(changeToAspectFitAction: @escaping ((_ playHaptic: Bool) -> Void) -> Void, changeToAspectFillAction: @escaping ((_ playHaptic: Bool) -> Void) -> Void, delegate: UIGestureRecognizerDelegate?)
    {
        m_ChangeToAspectFitAction = changeToAspectFitAction
        m_ChangeToAspectFillAction = changeToAspectFillAction
        
        super.init(target: nil, action: nil)
        
        self.name = ContentModeChangeGesture.s_GestureName
        self.delegate = delegate
        self.addTarget(self, action: #selector(didChangeContentMode))
    }
}

private extension ContentModeChangeGesture
{
    @objc private func didChangeContentMode(_ gesture: UIPinchGestureRecognizer)
    {
        if gesture.state == .ended
        {
            if gesture.scale < 0.75
            {
                ContentModeChangeGesture.s_Logger.debug("Changing content mode to aspect fit.")
                
                m_ChangeToAspectFitAction
                { playHaptic in
                    if playHaptic
                    {
                        CHHapticEngine.s_Shared?.play(.s_FallHapticPattern)
                    }
                }
            }
            else if gesture.scale > 1.25
            {
                ContentModeChangeGesture.s_Logger.debug("Changing content mode to aspect fill.")
                
                m_ChangeToAspectFillAction
                { playHaptic in
                    if playHaptic
                    {
                        CHHapticEngine.s_Shared?.play(.s_RiseHapticPattern)
                    }
                }
            }
        }
    }
}

