import Foundation

struct PLEngineSettings {
    var wakeThresholdEnabled = false
    var lockToScreenSaver = false
    var pauseNowPlaying = false
    var launchOnLogin = false
    var delayBeforeLocking = false
    var noSignalTimeout = false
    var showRSSIForAnyDevice = true

    var lockThreshold: DBm
    var wakeThreshold: DBm
}

struct PLEngineStatus: Identifiable, Equatable {
    let id = UUID()

    let type: PLEngineStatusType
    let messageKey: String?

    init(_ type: PLEngineStatusType = .ok, messageKey: String? = nil) {
        self.type = type
        self.messageKey = messageKey
    }

    static let ok: PLEngineStatus = .init()
}

enum PLEngineStatusType {
    case ok
    case error
}
