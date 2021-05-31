//
//
//  Workspace: ImagePlayer
//  MacOS Version: 11.4
//			
//  File Name: CHHapticEngine+Ext+ImagePlayer.swift
//  Creation: 5/31/21 8:08 PM
//
//  Author: Dragos-Costin Mandu
//
//


import CoreHaptics
import os

public extension CHHapticEngine
{
    // MARK: - Constants & Variables
    
    static var s_LoggerCategory: String = "CHHapticEngine"
    static let s_Logger: Logger = .init(subsystem: loggerSubsystem, category: s_LoggerCategory)
    
    /// A shared instance of a CHHapticEngine. Use it wisely 🤖.
    static var s_Shared: CHHapticEngine?
    {
        do
        {
            return try CHHapticEngine()
        }
        catch
        {
            s_Logger.error("Failed to initialize haptic engine with error: \(error.localizedDescription)")
        }
        
        return nil
    }
}

public extension CHHapticEngine
{
    // MARK: - Methods
    
    /// Tries to play the given haptic pattern, if supported.
    /// - Parameter pattern: The CHHapticPattern to be played.
    func play(_ pattern: CHHapticPattern?)
    {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics
        else
        {
            CHHapticEngine.s_Logger.error("Device doesn't support haptics.")
            
            return
        }
        
        if let pattern = pattern
        {
            do
            {
                let player = try makePlayer(with: pattern)
                
                start
                { (error) in
                    if let error = error
                    {
                        CHHapticEngine.s_Logger.error("Failed to start the haptic engine with error: \(error.localizedDescription)")
                        
                        return
                    }
                    
                    do
                    {
                        try player.start(atTime: 0)
                    }
                    catch let error
                    {
                        CHHapticEngine.s_Logger.error("Failed to play pattern with error: \(error.localizedDescription)")
                    }
                    
                    // Stops the engine when the player finished playing pattern.
                    self.notifyWhenPlayersFinished
                    { (error) -> FinishedAction in
                        if let error = error
                        {
                            CHHapticEngine.s_Logger.error("Failed to notify with error: \(error.localizedDescription)")
                        }
                        
                        return .leaveEngineRunning
                    }
                }
            }
            catch
            {
                CHHapticEngine.s_Logger.error("Failed to create a haptic pattern player with error: \(error.localizedDescription)")
            }
        }
        else
        {
            CHHapticEngine.s_Logger.debug("Invalid nil pattern.")
        }
    }
}

