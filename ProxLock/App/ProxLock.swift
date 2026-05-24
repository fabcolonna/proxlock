import SwiftUI

@main
struct ProxLock: App {
    static let appName = "ProxLock"

    @StateObject private var engine = PLEngine()

    var body: some Scene {
        MenuBarExtra(Self.appName, systemImage: "lock.fill") {
            RootView()
                .environmentObject(engine)
                .fixedSize()
                .background(.ultraThinMaterial)
        }
        .menuBarExtraStyle(.window)
        .windowResizability(.contentMinSize)
    }
}
