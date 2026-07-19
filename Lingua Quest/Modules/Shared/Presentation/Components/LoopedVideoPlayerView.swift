//
//  LoopedVideoPlayerView.swift
//  Lingua Quest
//
//  Created by siam on 18/07/2026.
//

import SwiftUI
import AVKit

class VideoHelper {
    static let shared = VideoHelper()
    private var tempURLs: [String: URL] = [:]
    
    func exists(videoName: String) -> Bool {
        if Bundle.main.url(forResource: videoName, withExtension: "mp4") != nil {
            return true
        }
        if Bundle.main.url(forResource: videoName, withExtension: "mov") != nil {
            return true
        }
        if NSDataAsset(name: videoName) != nil {
            return true
        }
        return false
    }
    
    func getURL(for videoName: String) -> URL? {
        // 1. Check if the video is inside the Bundle as a direct resource (e.g. loading.mp4)
        if let bundleURL = Bundle.main.url(forResource: videoName, withExtension: "mp4") {
            print("[VideoHelper] Found video in bundle: \(bundleURL.path)")
            return bundleURL
        }
        if let bundleURL = Bundle.main.url(forResource: videoName, withExtension: "mov") {
            print("[VideoHelper] Found video in bundle: \(bundleURL.path)")
            return bundleURL
        }
        
        // 2. Fallback to NSDataAsset (which resolves automatically in Assets)
        guard let dataAsset = NSDataAsset(name: videoName) else {
            print("[VideoHelper] Could not find NSDataAsset or bundle resource with name: \(videoName)")
            return nil
        }
        
        // Use a theme-specific temp file name so they don't overwrite each other while playing
        let isDark = UITraitCollection.current.userInterfaceStyle == .dark
        let suffix = isDark ? "_dark" : "_light"
        let cacheKey = "\(videoName)\(suffix)"
        
        if let url = tempURLs[cacheKey], FileManager.default.fileExists(atPath: url.path) {
            print("[VideoHelper] Found video in temp URLs: \(url.path)")
            return url
        }
        
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(videoName)\(suffix).mp4")
        do {
            try dataAsset.data.write(to: tempURL, options: .atomic)
            tempURLs[cacheKey] = tempURL
            print("[VideoHelper] Successfully wrote NSDataAsset \(videoName) (\(suffix)) to temp: \(tempURL.path)")
            return tempURL
        } catch {
            print("[VideoHelper] Failed to write video data asset: \(error)")
            return nil
        }
    }
}

struct LoopedVideoPlayerView: UIViewRepresentable {
    let videoAsset: Video.Asset
    @Environment(\.colorScheme) var colorScheme
    
    private func resolvedVideoName() -> String {
        let baseName = videoAsset.rawValue
        let suffix = colorScheme == .dark ? "_dark" : "_light"
        
        if VideoHelper.shared.exists(videoName: baseName + suffix) {
            return baseName + suffix
        }
        return baseName
    }
    
    func makeUIView(context: Context) -> PlayerUIView {
        let view = PlayerUIView()
        view.backgroundColor = .clear
        view.playerLayer.backgroundColor = UIColor.clear.cgColor
        view.playerLayer.videoGravity = .resizeAspectFill
        
        let videoName = resolvedVideoName()
        context.coordinator.currentVideoName = videoName
        context.coordinator.currentColorScheme = colorScheme
        print("[LoopedVideoPlayerView] makeUIView for: \(videoName) (scheme: \(colorScheme))")
        
        if let url = VideoHelper.shared.getURL(for: videoName) {
            print("[LoopedVideoPlayerView] Loading video from URL: \(url)")
            let playerItem = AVPlayerItem(url: url)
            let player = AVQueuePlayer(playerItem: playerItem)
            
            context.coordinator.playerItem = playerItem
            context.coordinator.player = player
            
            // Loop the video
            context.coordinator.looper = AVPlayerLooper(player: player, templateItem: playerItem)
            view.playerLayer.player = player
            
            // Observe item status
            let statusObserver = playerItem.observe(\.status, options: [.initial, .new]) { item, change in
                switch item.status {
                case .readyToPlay:
                    print("[LoopedVideoPlayerView] AVPlayerItem is ready to play. Player rate: \(player.rate)")
                    player.play()
                case .failed:
                    print("[LoopedVideoPlayerView] AVPlayerItem failed: \(String(describing: item.error))")
                case .unknown:
                    print("[LoopedVideoPlayerView] AVPlayerItem status is unknown")
                @unknown default:
                    print("[LoopedVideoPlayerView] AVPlayerItem status is @unknown")
                }
            }
            context.coordinator.statusObserver = statusObserver
            
            player.play()
            print("[LoopedVideoPlayerView] Play called, initial player rate: \(player.rate)")
        } else {
            print("[LoopedVideoPlayerView] URL is nil for video: \(videoName)")
        }
        
        return view
    }
    
    func updateUIView(_ uiView: PlayerUIView, context: Context) {
        let videoName = resolvedVideoName()
        
        // Reload if either the video name changed OR the color scheme changed
        guard videoName != context.coordinator.currentVideoName ||
              colorScheme != context.coordinator.currentColorScheme else { return }
        
        print("[LoopedVideoPlayerView] Color scheme or video changed, reloading video: \(videoName) (scheme: \(colorScheme))")
        context.coordinator.currentVideoName = videoName
        context.coordinator.currentColorScheme = colorScheme
        
        if let url = VideoHelper.shared.getURL(for: videoName) {
            let playerItem = AVPlayerItem(url: url)
            context.coordinator.playerItem = playerItem
            
            if let queuePlayer = context.coordinator.player as? AVQueuePlayer {
                context.coordinator.looper = nil
                queuePlayer.removeAllItems()
                
                context.coordinator.looper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
                
                let statusObserver = playerItem.observe(\.status, options: [.initial, .new]) { item, change in
                    if item.status == .readyToPlay {
                        queuePlayer.play()
                    }
                }
                context.coordinator.statusObserver = statusObserver
                queuePlayer.play()
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator {
        var looper: AVPlayerLooper?
        var playerItem: AVPlayerItem?
        var player: AVPlayer?
        var statusObserver: NSKeyValueObservation?
        var currentVideoName: String?
        var currentColorScheme: ColorScheme?
    }
}

class PlayerUIView: UIView {
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
}
