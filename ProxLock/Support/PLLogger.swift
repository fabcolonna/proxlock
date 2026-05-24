import Foundation
import OSLog

enum PLLogger {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "ProxLock", category: "ProxLock")

    static func debugRich(
        _ message: String,
        file: String? = #file,
        function: String? = #function,
        line: Int? = #line
    ) {
        guard let file, let function, let line else {
            logger.debug("\(message, privacy: .public)")
            return
        }

        let fileName = URL(fileURLWithPath: file).lastPathComponent
        logger
            .debug(
                "[\(fileName, privacy: .public):\(line) - \(function, privacy: .public)] \(message, privacy: .public)"
            )
    }

    static func debug(_ message: String) {
        PLLogger.debugRich(message, file: nil, function: nil, line: nil)
    }
}
