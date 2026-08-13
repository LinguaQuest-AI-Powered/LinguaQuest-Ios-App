//
//  SplashView.swift
//  Lingua Quest
//
//  Created by siam on 14/07/2026.
//

import SwiftUI
import AVKit

struct SplashConfig {
    static let totalDuration: Double = 3.5
}

struct SplashView: View {
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    // Logo shimmer
    @State private var shimmerOffset: CGFloat = -1.3

    // Ripple rings (3 staggered pulses expanding from the circle)
    @State private var ring1Scale: CGFloat = 0.85
    @State private var ring1Opacity: Double = 0.0
    @State private var ring2Scale: CGFloat = 0.85
    @State private var ring2Opacity: Double = 0.0
    @State private var ring3Scale: CGFloat = 0.85
    @State private var ring3Opacity: Double = 0.0

    // Mascot bobbing + wiggle
    @State private var birdOffsetY: CGFloat = 0
    @State private var birdRotation: Double = 0

    // Sparkle particles orbiting the circle
    private let sparkleCount = 8
    @State private var sparkleAngles: [Double] = []
    @State private var sparkleRadiusMultipliers: [CGFloat] = []
    @State private var sparkleSizes: [CGFloat] = []
    @State private var sparkleProgress: [CGFloat] = []

    // Stars twinkle
    @State private var star1Opacity: Double = 1.0
    @State private var star1Scale: CGFloat = 1.0
    @State private var star2Opacity: Double = 1.0
    @State private var star2Scale: CGFloat = 1.0

    // Bottom wordmark entrance
    @State private var bottomTextOpacity: Double = 0.0
    @State private var bottomTextOffsetY: CGFloat = 14

    var body: some View {
        GeometryReader { safeAreaProxy in
            let bottomInset = safeAreaProxy.safeAreaInsets.bottom

            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height

                let logoWidth = width * 0.76
                let logoCenterY = (height / 2) * 0.46

                let birdWidth = width * 0.64
                let birdCenterY = (height / 2) * 1.06
                let circleWidth = birdWidth * 1.1

                let star1Width = width * 0.10
                let star1CenterX = (width / 2) - (width * 0.32) + 10 - (width * 0.05)
                let star1CenterY = birdCenterY - (width * 0.32) + 10 - (width * 0.05)

                let star2Width = width * 0.076
                let star2CenterX = (width / 2) + (width * 0.32) - 10 + (width * 0.038)
                let star2CenterY = birdCenterY + (width * 0.32) - 30 + (width * 0.038)

                ZStack {
                    // Background
                    Color(red: 4/255, green: 115/255, blue: 125/255)
                        .ignoresSafeArea()

                    // Ripple rings — magical pulse expanding from the circle
                    rippleRing(scale: ring1Scale, opacity: ring1Opacity, size: circleWidth, x: width / 2, y: birdCenterY)
                    rippleRing(scale: ring2Scale, opacity: ring2Opacity, size: circleWidth, x: width / 2, y: birdCenterY)
                    rippleRing(scale: ring3Scale, opacity: ring3Opacity, size: circleWidth, x: width / 2, y: birdCenterY)

                    // Static placeholder image that matches the Launch Screen perfectly.
                    // This prevents any flicker or gap while AVPlayer is loading the first frame of the video.
                    Image("splashLaunchImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: circleWidth, height: circleWidth)
                        .clipShape(Circle())
                        .position(x: width / 2, y: birdCenterY)

                    // Splash Video
                    SplashVideoPlayer(videoName: "splash")
                        .frame(width: circleWidth, height: circleWidth)
                        .clipShape(Circle())
                        .position(x: width / 2, y: birdCenterY)
                    
                    // Sparkle particles orbiting the circle
                    ForEach(0..<sparkleAngles.count, id: \.self) { i in
                        sparkleView(
                            index: i,
                            centerX: width / 2,
                            centerY: birdCenterY,
                            baseRadius: circleWidth / 2
                        )
                    }

                    // Star 1
                    Image(.star)
                        .resizable()
                        .scaledToFit()
                        .frame(width: star1Width, height: star1Width)
                        .position(x: star1CenterX, y: star1CenterY)
                        .scaleEffect(star1Scale)
                        .opacity(star1Opacity)

                    // Star 2
                    Image(.star)
                        .resizable()
                        .scaledToFit()
                        .frame(width: star2Width, height: star2Width)
                        .position(x: star2CenterX, y: star2CenterY)
                        .scaleEffect(star2Scale)
                        .opacity(star2Opacity)

                    // Logo with shimmer sweep
                    shimmeringLogo(width: logoWidth)
                        .position(x: width / 2, y: logoCenterY)

                    // Bottom wordmark "LinguaQuest"
                    Text("LinguaQuest")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .position(x: width / 2, y: height - bottomInset - 54.5)
                        .opacity(bottomTextOpacity)
                        .offset(y: bottomTextOffsetY)
                }
                .onAppear {
                    setupSparkles()
                }
            }
            .ignoresSafeArea()
            .environment(\.layoutDirection, .leftToRight)
        }
        .onAppear {
            if reduceMotion {
                bottomTextOpacity = 1.0
                bottomTextOffsetY = 0
            } else {
                startAnimations()
            }
        }
    }

    // MARK: - Setup

    private func setupSparkles() {
        guard sparkleAngles.isEmpty else { return }
        sparkleAngles = (0..<sparkleCount).map { i in
            Double(i) * (360.0 / Double(sparkleCount)) + Double.random(in: -12...12)
        }
        sparkleRadiusMultipliers = (0..<sparkleCount).map { _ in CGFloat.random(in: 0.95...1.15) }
        sparkleSizes = (0..<sparkleCount).map { _ in CGFloat.random(in: 5...10) }
        sparkleProgress = Array(repeating: 0, count: sparkleCount)
    }

    // MARK: - Shimmer Logo

    @ViewBuilder
    private func shimmeringLogo(width: CGFloat) -> some View {
        Image(.linguaQuest)
            .resizable()
            .scaledToFit()
            .frame(width: width)
            .overlay(
                GeometryReader { proxy in
                    LinearGradient(
                        colors: [.clear, .white.opacity(0.85), .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: proxy.size.width * 0.5)
                    .rotationEffect(.degrees(20))
                    .offset(x: shimmerOffset * proxy.size.width)
                    .blendMode(.plusLighter)
                }
                .mask(
                    Image(.linguaQuest)
                        .resizable()
                        .scaledToFit()
                        .frame(width: width)
                )
            )
    }

    // MARK: - Ripple Ring

    @ViewBuilder
    private func rippleRing(scale: CGFloat, opacity: Double, size: CGFloat, x: CGFloat, y: CGFloat) -> some View {
        Circle()
            .stroke(Color.white.opacity(0.5), lineWidth: 2.5)
            .frame(width: size, height: size)
            .scaleEffect(scale)
            .opacity(opacity)
            .position(x: x, y: y)
    }

    // MARK: - Sparkle Particle

    @ViewBuilder
    private func sparkleView(index: Int, centerX: CGFloat, centerY: CGFloat, baseRadius: CGFloat) -> some View {
        let radians = sparkleAngles[index] * .pi / 180
        let radius = baseRadius * sparkleRadiusMultipliers[index]
        let x = centerX + cos(radians) * radius
        let y = centerY + sin(radians) * radius
        let progress = sparkleProgress[index]
        let opacity = progress > 0.5 ? Double(2 - progress * 2) : Double(progress * 2)
        let scale = 0.5 + progress * 0.7

        Image(systemName: "sparkle")
            .resizable()
            .scaledToFit()
            .frame(width: sparkleSizes[index], height: sparkleSizes[index])
            .foregroundColor(.white)
            .opacity(opacity)
            .scaleEffect(scale)
            .position(x: x, y: y)
    }

    // MARK: - Animation Choreography

    private func startAnimations() {
        // Logo shimmer sweep — elegant light passing over the wordmark, twice
        withAnimation(.easeInOut(duration: 0.9).delay(0.15).repeatCount(2, autoreverses: false)) {
            shimmerOffset = 1.3
        }

        // Ripple rings — 3 staggered expanding pulses (entrance)
        animateRippleOnce(scale: $ring1Scale, opacity: $ring1Opacity, delay: 0.1)
        animateRippleOnce(scale: $ring2Scale, opacity: $ring2Opacity, delay: 0.5)
        animateRippleOnce(scale: $ring3Scale, opacity: $ring3Opacity, delay: 0.9)

        // Continuous ripple loop after entrance settles — keeps the screen feeling alive
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            ring1Scale = 0.85
            ring1Opacity = 0.6
            withAnimation(.easeOut(duration: 1.2).repeatForever(autoreverses: false)) {
                ring1Scale = 1.5
                ring1Opacity = 0.0
            }
        }

        // Mascot bobbing (continuous float up/down)
        withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
            birdOffsetY = -10
        }
        // Mascot gentle wiggle
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                birdRotation = 3.5
            }
        }

        // Stars twinkle continuously, staggered
        animateStarLoop(delay: 0.2, opacityBinding: $star1Opacity, scaleBinding: $star1Scale)
        animateStarLoop(delay: 0.6, opacityBinding: $star2Opacity, scaleBinding: $star2Scale)

        // Sparkles orbiting fade in/out, staggered
        for i in 0..<sparkleProgress.count {
            let delay = Double(i) * 0.12
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeInOut(duration: 1.3).repeatForever(autoreverses: true)) {
                    sparkleProgress[i] = 1.0
                }
            }
        }

        // Bottom wordmark — fades and slides up after the main entrance settles
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                bottomTextOpacity = 1.0
                bottomTextOffsetY = 0
            }
        }
    }

    private func animateRippleOnce(scale: Binding<CGFloat>, opacity: Binding<Double>, delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            scale.wrappedValue = 0.85
            opacity.wrappedValue = 0.7
            withAnimation(.easeOut(duration: 0.9)) {
                scale.wrappedValue = 1.5
                opacity.wrappedValue = 0.0
            }
        }
    }

    private func animateStarLoop(delay: Double, opacityBinding: Binding<Double>, scaleBinding: Binding<CGFloat>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                opacityBinding.wrappedValue = 0.5
                scaleBinding.wrappedValue = 0.85
            }
        }
    }
}

// MARK: - Video Player Components
struct SplashVideoPlayer: UIViewRepresentable {
    let videoName: String
    
    func makeUIView(context: Context) -> SplashPlayerUIView {
        let view = SplashPlayerUIView()
        if let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") {
            let player = AVPlayer(url: url)
            player.isMuted = true
            view.playerLayer.player = player
            player.play()
            
            NotificationCenter.default.addObserver(
                forName: .AVPlayerItemDidPlayToEndTime,
                object: player.currentItem,
                queue: .main
            ) { _ in
                player.seek(to: .zero)
                player.play()
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: SplashPlayerUIView, context: Context) {}
}

class SplashPlayerUIView: UIView {
    let playerLayer = AVPlayerLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}

#Preview {
    SplashView()
}
