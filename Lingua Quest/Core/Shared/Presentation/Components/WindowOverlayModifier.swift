import SwiftUI

struct WindowOverlayModifier<OverlayContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let overlayContent: () -> OverlayContent

    @State private var overlayWindow: UIWindow?

    func body(content: Content) -> some View {
        content
            .onChange(of: isPresented) { _, newValue in
                if newValue {
                    showOverlay()
                } else {
                    hideOverlay()
                }
            }
            .onAppear {
                if isPresented { showOverlay() }
            }
            .onDisappear {
                hideOverlay()
            }
    }

    private func showOverlay() {
        guard overlayWindow == nil, let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = .clear
        
        let hostingController = UIHostingController(
            rootView: overlayContent()
                // Inject the current environment if needed, but for simplicity we assume the overlay is self-contained
                .ignoresSafeArea()
        )
        hostingController.view.backgroundColor = .clear
        window.rootViewController = hostingController
        window.windowLevel = .normal + 1 // Above main window but below alerts
        window.isHidden = false
        
        self.overlayWindow = window
    }

    private func hideOverlay() {
        overlayWindow?.isHidden = true
        overlayWindow = nil
    }
}

extension View {
    func windowOverlay<OverlayContent: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> OverlayContent
    ) -> some View {
        self.modifier(WindowOverlayModifier(isPresented: isPresented, overlayContent: content))
    }
}
