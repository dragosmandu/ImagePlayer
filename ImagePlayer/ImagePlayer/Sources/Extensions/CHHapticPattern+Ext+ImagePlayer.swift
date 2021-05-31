//
//
//  Workspace: ImagePlayer
//  MacOS Version: 11.4
//			
//  File Name: CHHapticPattern+Ext+ImagePlayer.swift
//  Creation: 5/31/21 8:11 PM
//
//  Author: Dragos-Costin Mandu
//
//


import CoreHaptics
import os

public extension CHHapticPattern
{
    // MARK: - Constants & Variables
    
    static var s_LoggerCategory: String = "CHHapticPattern"
    static let s_Logger: Logger = .init(subsystem: loggerSubsystem,category: s_LoggerCategory)
    
    /// A haptic pattern that feels like popping out.
    static var s_FallHapticPattern: CHHapticPattern?
    {
        var fallHapticPattern: CHHapticPattern?
        let fallHapticEvent = CHHapticEvent.s_FallHapticEvent
        
        fallHapticEvent.relativeTime = 0
        
        do
        {
            fallHapticPattern = try CHHapticPattern(events: [fallHapticEvent], parameters: [])
        }
        catch
        {
            debugPrint(error)
        }
        
        return fallHapticPattern
    }
    
    /// A haptic pattern that feels like popping in.
    static var s_RiseHapticPattern: CHHapticPattern?
    {
        var riseHapticPattern: CHHapticPattern?
        let riseHapticEvent = CHHapticEvent.s_RiseHapticEvent
        
        riseHapticEvent.relativeTime = 0
        
        do
        {
            riseHapticPattern = try CHHapticPattern(events: [riseHapticEvent], parameters: [])
        }
        catch
        {
            debugPrint(error)
        }
        
        return riseHapticPattern
    }
    
    /// Should be used for clicks.
    static var s_ClickHapticPattern: CHHapticPattern?
    {
        var clickHapticPattern: CHHapticPattern?
        let clickHapticEvent = CHHapticEvent.s_ClickHapticEvent
        
        clickHapticEvent.relativeTime = 0
        
        do
        {
            clickHapticPattern = try CHHapticPattern(events: [clickHapticEvent], parameters: [])
        }
        catch
        {
            debugPrint(error)
        }
        
        return clickHapticPattern
    }
    
    /// A haptic pattern that feels like an on switch.
    static var s_OnHapticPattern: CHHapticPattern?
    {
        var onHapticPattern: CHHapticPattern?
        let fallHapticEvent = CHHapticEvent.s_FallHapticEvent
        let riseHapticEvent = CHHapticEvent.s_RiseHapticEvent
        
        fallHapticEvent.relativeTime = 0
        riseHapticEvent.relativeTime = CHHapticEvent.s_FallHapticEventDuration
        
        do
        {
            onHapticPattern = try CHHapticPattern(events: [fallHapticEvent, riseHapticEvent], parameters: [])
        }
        catch
        {
            debugPrint(error)
        }
        
        return onHapticPattern
    }
    
    /// A haptic pattern that feels like an off switch.
    static var s_OffHapticPattern: CHHapticPattern?
    {
        var offHapticPattern: CHHapticPattern?
        let riseHapticEvent = CHHapticEvent.s_RiseHapticEvent
        let fallHapticEvent = CHHapticEvent.s_FallHapticEvent
        
        riseHapticEvent.relativeTime = 0
        fallHapticEvent.relativeTime = CHHapticEvent.s_RiseHapticEventDuration
        
        do
        {
            offHapticPattern = try CHHapticPattern(events: [riseHapticEvent, fallHapticEvent], parameters: [])
        }
        catch
        {
            debugPrint(error)
        }
        
        return offHapticPattern
    }
}


