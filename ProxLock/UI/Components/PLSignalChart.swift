import SwiftUI

struct PLSignalChart: View {
    let range: ClosedRange<DBm>
    let step: Double
    let rssi: DBm

    private var ledCount: Int {
        Int(abs(range.upperBound - range.lowerBound) / step + 1)
    }

    var body: some View {
        HStack {
            ForEach(0 ..< ledCount, id: \.self) { i in
                Rectangle()
                    .fill(i <= mapRssiToIdx() ? .green : .white.opacity(0.2))
                    .cornerRadius(4)
            }
        }
    }

    private func mapRssiToIdx() -> Int {
        guard !rssi.isNaN else { return -1 }

        let normalizedRSSI = (rssi - range.lowerBound) / (range.upperBound - range.lowerBound)
        let index = Int(round(normalizedRSSI * Double(ledCount - 1)))
        return min(max(index, -1), ledCount - 1)
    }
}
