import CocoaLumberjack

class CocoaLumberjackConsoleFormatter: NSObject {
	/// The date formatter to use which is cached by this property so no other messes with it.
	private let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.formatterBehavior = .behavior10_4
		formatter.dateFormat = "HH:mm:ss"
		return formatter
	}()
}

extension CocoaLumberjackConsoleFormatter: DDLogFormatter {
	/**
	 Formats given log message.

	 - parameter logMessage: The log message to format.
	 - returns: The formatted string.
	 */
	func format(message logMessage: DDLogMessage) -> String? {
		let timestamp = dateFormatter.string(from: logMessage.timestamp)

		var level: String
		let logFlag = logMessage.flag
		if logFlag.contains(.error) {
			level = "💣 |E|"
		} else if logFlag.contains(.warning) {
			level = "⚠️️ |W|"
		} else if logFlag.contains(.info) {
			level = "🔖 |I|"
		} else if logFlag.contains(.debug) {
			level = "💬 |D|"
		} else if logFlag.contains(.verbose) {
			level = "💭 |V|"
		} else {
			level = "💥 |?|"
		}

		return "\(level) \(timestamp) \(logMessage.fileName.description).\(logMessage.function!.description):\(logMessage.line):\n\(logMessage.message.description)"
	}
}
