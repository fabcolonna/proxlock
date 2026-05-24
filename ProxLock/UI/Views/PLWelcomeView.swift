import SwiftUI

struct PLWelcomeView: View {
    @Binding var mainSwitch: Bool

    var body: some View {
        VStack {
            Spacer()

            HStack {
                Image(systemName: "lock.open.fill")
                    .font(.system(size: 31, weight: .bold))
                    .shadow(radius: 5)

                Text(ProxLock.appName)
                    .font(.system(size: 31, weight: .bold))
                    .shadow(radius: 5)
            }

            Toggle("app.enabled", isOn: $mainSwitch)
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                .labelsHidden()
                .shadow(radius: 5)

            Spacer()
        }
    }
}
