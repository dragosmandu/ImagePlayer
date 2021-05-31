//
//
//  Workspace: ImagePlayer
//  MacOS Version: 11.4
//			
//  File Name: CHHapticEvent+Ext+ImagePlayer.swift
//  Creation: 5/31/21 8:10 PM
//
//  Author: Dragos-Costin Mandu
//
//



import CoreHaptics

public extension CHHapticEvent
{
    // MARK: - Constants & Variables
    
    static var s_FallHapticEventDuration: Double = 0.2
    static var s_FallHapticEventIntensity: Float = 0.6
    static var s_FallHapticEventSharpness: Float = 0.3
    
    static var s_RiseHapticEventDuration: Double = 0.3
    static var s_RiseHapticEventIntensity: Float = 1
    static var s_RiseHapticEventSharpness: Float = 0.4
    
    static var s_ClickHapticEventDuration: Double = 0.3
    static var s_ClickHapticEventIntensity: Float = 0.8
    static var s_ClickHapticEventSharpness: Float = 0.2
    
    /// Event to create a haptic pattern that feels like a fall.
    static var s_FallHapticEvent: CHHapticEvent
    {
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: s_FallHapticEventIntensity)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: s_FallHapticEventSharpness)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0, duration: s_FallHapticEventDuration)
        
        return event
    }
    
    /// Event to create a haptic pattern that feels like a rise.
    static var s_RiseHapticEvent: CHHapticEvent
    {
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: s_RiseHapticEventIntensity)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: s_RiseHapticEventSharpness)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0, duration: s_RiseHapticEventDuration)
        
        return event
    }
    
    /// Event to create a haptic pattern that may be used for clicks.
    static var s_ClickHapticEvent: CHHapticEvent
    {
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: s_ClickHapticEventIntensity)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: s_ClickHapticEventSharpness)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0, duration: s_ClickHapticEventDuration)
        
        return event
    }
}

