import SwiftUI

struct PLHeaderPanel: View {
    @EnvironmentObject var engine: PLEngine

    @Binding var mainSwitch: Bool

    var body: some View {
        VStack {
            HStack {
                HStack {
                    Toggle("app.enabled", isOn: $mainSwitch)
                        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                        .labelsHidden()
                        .shadow(radius: 5)

                    Image(systemName: "lock.fill")
                        .font(.system(size: 15, weight: .bold))
                        .shadow(radius: 5)

                    Text(ProxLock.appName)
                        .font(.system(size: 15, weight: .bold))
                        .shadow(radius: 5)
                }

                Spacer()

                HStack {
                    if engine.monitoredDevice != nil {
                        Button { engine.unsetMonitoredDevice() } label: {
                            Text("device.stopUsing")
                        }
                    }

                    Button { NSApplication.shared.terminate(nil) } label: {
                        Image(systemName: "power.circle.fill")
                            .font(.system(size: 20.0, weight: .regular))
                            .foregroundColor(.red)
                    }
                    .buttonStyle(.plain)
                    .shadow(radius: 5)
                    .accessibilityLabel(Text("app.quit"))
                }
            }
        }
    }
}
