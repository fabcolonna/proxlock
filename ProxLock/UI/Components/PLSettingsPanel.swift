import SwiftUI

struct PLSettingsPanel: View {
    @Binding var settings: PLEngineSettings

    let stepperRange: ClosedRange<DBm>
    let dBmStep: Double

    @State private var expanded = false

    private var header: some View {
        HStack {
            Text("settings.title")
                .font(.system(size: 13, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()

            Button { withAnimation(.bouncy) { expanded.toggle() } } label: {
                Image(systemName: expanded ? "chevron.down" : "chevron.up")
            }
            .buttonStyle(.plain)
        }
        .contentShape(Rectangle())
        .onTapGesture { withAnimation(.bouncy) { expanded.toggle() } }
    }

    var body: some View {
        PLPanel {
            header

            if expanded {
                VStack {
                    PLToggle(
                        isOn: $settings.wakeThresholdEnabled,
                        symbol: "wake",
                        text: "settings.wakeThreshold.enabled"
                    )
                    .onChange(of: settings.wakeThresholdEnabled) { _, value in
                        withAnimation(.bouncy) {
                            settings.wakeThreshold = value ? stepperRange.upperBound : .nan
                        }
                    }

                    PLToggle(isOn: $settings.lockToScreenSaver, symbol: "photo", text: "settings.lockToScreenSaver")
                    PLToggle(isOn: $settings.pauseNowPlaying, symbol: "pause.fill", text: "settings.pauseNowPlaying")
                }

                Divider()

                VStack {
                    PLToggle(isOn: $settings.launchOnLogin, symbol: "app.dashed", text: "settings.launchAtLogin")
                    PLToggle(isOn: $settings.delayBeforeLocking, symbol: "clock", text: "settings.lockDelay")
                    PLToggle(
                        isOn: $settings.noSignalTimeout,
                        symbol: "antenna.radiowaves.left.and.right.slash",
                        text: "settings.noSignalTimeout"
                    )
                    PLToggle(isOn: $settings.showRSSIForAnyDevice, symbol: "textformat.123", text: "settings.showRSSI")
                }

                Divider()

                VStack {
                    PLStepper(
                        value: $settings.lockThreshold,
                        range: stepperRange,
                        symbol: "sleep",
                        text: "settings.lockThreshold",
                        step: dBmStep
                    )

                    if settings.wakeThresholdEnabled {
                        PLStepper(
                            value: $settings.wakeThreshold,
                            range: stepperRange,
                            symbol: "wake",
                            text: "settings.wakeThreshold",
                            step: dBmStep
                        )
                    }
                }
            }
        }
    }
}

private struct PLToggle: View {
    @Binding var isOn: Bool

    let symbol: String
    let text: LocalizedStringKey

    var body: some View {
        HStack {
            Image(systemName: symbol)
                .frame(width: 20, height: 20)

            Text(text)
            Spacer()

            Toggle(text, isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                .labelsHidden()
        }
        .padding(2)
    }
}

private struct PLStepper: View {
    @Binding var value: DBm

    let range: ClosedRange<DBm>
    let symbol: String
    let text: LocalizedStringKey
    let step: Double

    var body: some View {
        HStack {
            Image(systemName: symbol)
            Text(text)
            Spacer()

            Stepper(value: $value, in: range, step: step) {
                Text("\(String(format: "%.0f", value)) dBm")
                    .font(.system(size: 12, design: .monospaced))
            }
        }
    }
}
