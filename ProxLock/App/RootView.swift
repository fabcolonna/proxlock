import SwiftUI

struct RootView: View {
    @EnvironmentObject var engine: PLEngine

    @State private var mainSwitch = false

    var body: some View {
        VStack {
            if mainSwitch {
                PLMainView(mainSwitch: $mainSwitch)
            } else {
                PLWelcomeView(mainSwitch: $mainSwitch)
            }
        }
        .padding()
        .frame(width: 350)
    }
}

#Preview {
    RootView()
        .environmentObject(PLEngine())
        .frame(height: 700)
}
