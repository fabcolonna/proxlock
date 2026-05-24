import SwiftUI

struct PLMonitorPanel: View {
    @EnvironmentObject var engine: PLEngine

    let dBmStep: Double

    @State private var showRSSI = false

    private let chartRange: ClosedRange<DBm> = -85.0 ... -25.0

    var body: some View {
        if let device = engine.monitoredDevice {
            HStack(spacing: 12) {
                Image(systemName: device.type.symbolName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)

                VStack(alignment: .leading) {
                    HStack {
                        Text(device.name)
                            .fontWeight(.bold)
                            .lineLimit(1)

                        Spacer()

                        if showRSSI {
                            Text(device.rssi.isNaN ? "" : "\(String(format: "%.0f", device.rssi)) dBm")
                                .font(.system(size: 12, design: .monospaced))
                                .frame(alignment: .trailing)
                                .padding(.trailing)
                                .opacity(showRSSI ? 1.0 : 0.0)
                                .scaleEffect(showRSSI ? 1.0 : 0.5)
                        }
                    }

                    PLSignalChart(range: chartRange, step: dBmStep, rssi: device.rssi)
                        .frame(height: 25)
                }
            }
            .onAppear { showRSSI = engine.settings.showRSSIForAnyDevice }
            .onChange(of: engine.settings.showRSSIForAnyDevice) { _, value in
                withAnimation(.easeInOut) { showRSSI = value }
            }
        } else {
            HStack(spacing: 12) {
                Image(systemName: "dot.radiowaves.left.and.right")
                    .font(.system(size: 30, weight: .medium))
                    .frame(width: 60, height: 60)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 4) {
                    Text("monitor.noDevice.title")
                        .fontWeight(.bold)
                        .lineLimit(1)

                    Text("monitor.noDevice.subtitle")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer()
            }
        }
    }
}
