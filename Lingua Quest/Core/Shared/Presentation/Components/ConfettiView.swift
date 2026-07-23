//
//  ConfettiView.swift
//  Lingua Quest
//
//  Created by siam on 19/07/2026.
//

import SwiftUI

struct ConfettiView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: -50)
        emitter.emitterShape = .line
        emitter.emitterSize = CGSize(width: UIScreen.main.bounds.width, height: 1)
        
        let colors: [UIColor] = [
            UIColor(Color.appAccentOrange),
            UIColor(Color.appGlowTeal),
            UIColor(Color.appBrandPrimary),
            UIColor(Color.appAccentGold),
            .systemRed,
            .systemPink
        ]
        
        emitter.emitterCells = colors.map { color in
            let cell = CAEmitterCell()
            cell.birthRate = 8.0
            cell.lifetime = 10.0
            cell.velocity = 250
            cell.velocityRange = 100
            cell.emissionLongitude = .pi
            cell.emissionRange = .pi / 4
            cell.spin = 2
            cell.spinRange = 3
            cell.scale = 0.4
            cell.scaleRange = 0.2
            
            // Create a small confetti image programmatically
            let size = CGSize(width: 12, height: 12)
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            color.setFill()
            UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: 2).fill()
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            cell.contents = image?.cgImage
            return cell
        }
        
        view.layer.addSublayer(emitter)
        
        // Stop emitting after 1.5 seconds for a burst effect
        Task { @MainActor [weak view] in
            try? await Task.sleep(for: .seconds(1.5))
            if let targetEmitter = view?.layer.sublayers?.first(where: { $0 is CAEmitterLayer }) as? CAEmitterLayer {
                targetEmitter.birthRate = 0
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
