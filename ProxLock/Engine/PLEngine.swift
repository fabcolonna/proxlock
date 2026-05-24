import CoreBluetooth
import Foundation

typealias DBm = Double

@MainActor
final class PLEngine: NSObject, ObservableObject {
    private let minimumRssiBeforeUnavailable: DBm = -85.0

    private lazy var manager = CBCentralManager(delegate: self, queue: .main)
    private var bluetoothStatus: PLEngineStatus = .ok
    private var settingsStatus: PLEngineStatus = .ok

    let range: ClosedRange<DBm> = -80.0 ... -30.0
    let dBmStep: Double = 5.0

    @Published private(set) var status: PLEngineStatus
    @Published var settings: PLEngineSettings
    @Published private(set) var monitoredDevice: PLDevice?
    @Published private(set) var allDevices: [UUID: PLDevice] = [:]

    var allDevicesSortedByRSSI: [PLDevice] {
        allDevices.values.sorted { $0.rssi > $1.rssi }
    }

    var isScanning: Bool {
        manager.isScanning
    }

    override init() {
        status = .ok
        settings = PLEngineSettings(lockThreshold: range.lowerBound, wakeThreshold: .nan)
        super.init()
    }

    func startScan() {
        guard !manager.isScanning else { return }

        if bluetoothStatus.type != .ok {
            PLLogger.debug("Got start scan request. Refused: Status is not OK")
            return
        }

        PLLogger.debug("Got start scan request. OK")
        manager.scanForPeripherals(withServices: nil, options: [
            CBCentralManagerScanOptionAllowDuplicatesKey: true
        ])
    }

    func stopScan() {
        guard manager.isScanning else {
            PLLogger.debug("Got stop scan request. Refused: Central was not scanning")
            return
        }

        PLLogger.debug("Got stop scan request. OK")
        manager.stopScan()
        allDevices.removeAll()
    }

    func setMonitoredDevice(uuid: UUID) {
        monitoredDevice = allDevices[uuid]
        allDevices.removeValue(forKey: uuid)
    }

    func unsetMonitoredDevice() {
        monitoredDevice = nil
    }

    func updateSettingsStatus(_ status: PLEngineStatus) {
        settingsStatus = status
        refreshStatus()
    }

    private func updateBluetoothStatus(_ status: PLEngineStatus) {
        bluetoothStatus = status
        refreshStatus()
    }

    private func refreshStatus() {
        status = bluetoothStatus.type == .error ? bluetoothStatus : settingsStatus
    }
}

extension PLEngine: @preconcurrency CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            updateBluetoothStatus(.ok)
            PLLogger.debug("Central status update: OK")
        case .poweredOff:
            updateBluetoothStatus(PLEngineStatus(.error, messageKey: "error.bluetoothOff"))
            PLLogger.debug("Central status update: BT OFF")
        default:
            updateBluetoothStatus(PLEngineStatus(.error, messageKey: "error.bluetoothUnavailable"))
            PLLogger.debug("Central status update: FATAL")
        }
    }

    func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String: Any],
        rssi RSSI: NSNumber
    ) {
        guard let name = peripheral.name,
              let isConnectable = advertisementData[CBAdvertisementDataIsConnectable] as? Bool,
              isConnectable
        else { return }

        guard let info = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data,
              let deviceType: PLDeviceType = .fromManufacturerData(info)
        else { return }

        let uuid = peripheral.identifier
        let rssi = DBm(truncating: RSSI)

        if uuid == monitoredDevice?.uuid {
            let oldRSSI = monitoredDevice?.rssi ?? .nan
            monitoredDevice?.updateData(state: peripheral.state, rssi: rssi)
            PLLogger.debug("[SCAN MONITORED] Updating \(name): RSSI=[\(oldRSSI) -> \(rssi)]")
            return
        }

        if rssi < minimumRssiBeforeUnavailable {
            PLLogger.debug("[SCAN] Device \(name) has RSSI below minimum (was \(rssi)): Ignoring it")
            allDevices.removeValue(forKey: uuid)
            return
        }

        guard let dev = allDevices[uuid] else {
            PLLogger.debug("[SCAN] Adding new device: \(name)")
            allDevices[uuid] = .init(type: deviceType, uuid: uuid, name: name, rssi: rssi)
            return
        }

        let oldRSSI = dev.rssi
        allDevices[uuid]?.updateData(state: peripheral.state, rssi: rssi)

        PLLogger.debug("[SCAN] Updating device \(name): RSSI=[\(oldRSSI) -> \(rssi)]")
    }
}
