import SwiftUI

struct PLDevicesPanel: View {
    @EnvironmentObject var engine: PLEngine

    @Binding var errored: Bool

    @State private var expanded = true

    private var header: some View {
        HStack {
            Text("devices.available.title")
                .font(.system(size: 13, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()

            Button {
                if !errored { withAnimation(.bouncy) { expanded.toggle() } }
            } label: { Image(systemName: expanded ? "chevron.down" : "chevron.up") }
                .buttonStyle(.plain)
        }
        .contentShape(Rectangle())
        .onTapGesture { if !errored { withAnimation(.bouncy) { expanded.toggle() } } }
    }

    var body: some View {
        PLPanel {
            header

            if !errored, expanded {
                VStack(spacing: 10) {
                    if engine.allDevicesSortedByRSSI.isEmpty {
                        ProgressView()
                            .controlSize(.small)
                        Text("devices.scanning")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .opacity(expanded ? 1.0 : 0.0)
                    } else {
                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach(engine.allDevicesSortedByRSSI, id: \.id) { dev in
                                    PLDeviceEntry(device: dev)
                                        .transition(.opacity)
                                        .onTapGesture { engine.setMonitoredDevice(uuid: dev.uuid) }
                                }
                            }
                        }
                    }
                }
            }
        }
        .opacity(!errored ? 1.0 : 0.5)
    }
}

private struct PLDeviceEntry: View {
    @EnvironmentObject var engine: PLEngine

    let device: PLDevice

    @State private var showRSSI = false
    @State private var isHovered = false

    private let chartRange: ClosedRange<DBm> = -80.0 ... -35.0
    private let step = 15.0

    var body: some View {
        ZStack {
            Color(white: 0.1, opacity: 0.5)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .opacity(isHovered ? 0.2 : 0.0)

            HStack {
                Image(systemName: device.type.symbolName)
                    .font(.system(size: 24.0))

                Text(device.name)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Spacer()

                if showRSSI {
                    Text(device.rssi.isNaN ? "" : "\(String(format: "%.0f", device.rssi))")
                        .font(.system(size: 10, design: .monospaced))
                        .opacity(showRSSI ? 1.0 : 0.0)
                        .scaleEffect(showRSSI ? 1.0 : 0.5)
                }

                PLSignalChart(range: chartRange, step: step, rssi: device.rssi)
                    .frame(width: 70, height: 18)
                    .padding(.trailing)
            }
            .padding(4)
            .buttonStyle(.plain)
            .overlay(
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(white: 0.1, opacity: 0.5), lineWidth: 0.5)

                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(white: 0.4), lineWidth: 0.5)
                        .padding(0.5)
                }
                .opacity(isHovered ? 0.5 : 0.2)
            )
            .onHover(perform: { hovering in
                withAnimation { isHovered = hovering }
            })
            .onChange(of: engine.settings.showRSSIForAnyDevice) { _, value in
                withAnimation(.easeInOut) { showRSSI = value }
            }
            .onAppear { showRSSI = engine.settings.showRSSIForAnyDevice }
        }
    }
}
