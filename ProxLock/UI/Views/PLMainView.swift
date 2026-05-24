import SwiftUI

struct PLMainView: View {
    @EnvironmentObject var engine: PLEngine

    @Binding var mainSwitch: Bool

    @State private var errored = false

    var body: some View {
        content
            .onAppear { engine.startScan() }
            .onDisappear { engine.stopScan() }
    }

    @ViewBuilder private var content: some View {
        if #available(macOS 26.0, *) {
            GlassEffectContainer(spacing: 10) {
                panelStack
            }
        } else {
            panelStack
        }
    }

    private var panelStack: some View {
        VStack(spacing: 10) {
            PLHeaderPanel(mainSwitch: $mainSwitch)
                .transition(.opacity)

            PLPanel {
                ZStack {
                    PLMonitorPanel(dBmStep: engine.dBmStep)
                        .transition(.opacity)
                        .blur(radius: errored ? 10.0 : 0.0)
                        .opacity(errored ? 0.5 : 1.0)

                    if let errorKey = engine.status.messageKey {
                        PLErrorPanel(errorKey: errorKey)
                            .transition(.opacity)
                            .opacity(errored ? 1.0 : 0.0)
                            .onAppear { withAnimation(.bouncy) { errored = true } }
                            .onDisappear { withAnimation(.bouncy) { errored = false } }
                    }
                }
            }
            .frame(height: errored ? nil : 80)

            PLDevicesPanel(errored: $errored)

            PLSettingsPanel(settings: $engine.settings, stepperRange: engine.range, dBmStep: engine.dBmStep)
                .onChange(of: [engine.settings.lockThreshold, engine.settings.wakeThreshold]) {
                    validateSettings()
                }
                .onChange(of: engine.settings.wakeThresholdEnabled) { validateSettings() }
        }
    }

    private func validateSettings() {
        guard engine.settings.wakeThresholdEnabled else {
            if engine.status.messageKey == "error.invalidThreshold" {
                engine.updateSettingsStatus(.ok)
            }
            return
        }

        engine.updateSettingsStatus(
            engine.settings.lockThreshold >= engine.settings.wakeThreshold
                ? PLEngineStatus(.error, messageKey: "error.invalidThreshold")
                : .ok
        )
    }
}
