import CoreBluetooth
import Foundation

struct PLDevice: Identifiable, Hashable {
    let uuid: UUID
    let type: PLDeviceType
    let name: String

    var state: CBPeripheralState
    var rssi: DBm

    var id: UUID {
        uuid
    }

    init(
        type: PLDeviceType,
        uuid: UUID,
        name: String,
        state: CBPeripheralState = .disconnected,
        rssi: DBm = .nan
    ) {
        self.uuid = uuid
        self.type = type
        self.name = name
        self.state = state
        self.rssi = rssi
    }

    mutating func updateData(state: CBPeripheralState, rssi: DBm) {
        self.state = state
        self.rssi = rssi
    }

    static let mock: PLDevice = .init(type: .airPodsPro, uuid: UUID(), name: "AirPods")
}

enum PLDeviceType: Hashable {
    case iPhone
    case appleWatch
    case airPods
    case airPods3
    case airPodsPro
    case airPodsMax

    var symbolName: String {
        switch self {
        case .iPhone: "iphone"
        case .appleWatch: "applewatch.side.right"
        case .airPods: "airpods"
        case .airPods3: "airpods.gen3"
        case .airPodsPro: "airpodspro"
        case .airPodsMax: "airpodsmax"
        }
    }

    static func fromManufacturerData(_ data: Data) -> PLDeviceType? {
        let appleByteSequence: [UInt8] = [0x4C, 0x00]

        return data.prefix(2).elementsEqual(appleByteSequence) ? .airPods3 : nil
    }
}
