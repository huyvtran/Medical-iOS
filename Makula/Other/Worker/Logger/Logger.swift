import CocoaLumberjack

/**
 A logger, respectively a thin wrapper for the logger to use.
 Only log via this class, don't call the underlaying logger directly.
 */
final class Log {
	/**
	 Sets up the logging with `CocoaLumberjack`.
	 Has to be called once during app start.
	 */
	static func setup() {
		// Set `CocoaLumberjack`'s log level, everything on this level or more critical will be logged.
		#if DEBUG
			// Log for debug mode.
			defaultDebugLevel = .debug
		#else
			// Log for release mode.
			defaultDebugLevel = .info
		#endif

		// Use the Xcode console for log output.
		DDLog.add(DDTTYLogger.sharedInstance) // TTY = Xcode console
		DDTTYLogger.sharedInstance.logFormatter = CocoaLumberjackConsoleFormatter()

		// Since Xcode 8 colors are not supported anymore, but maybe they will be again some day...
		DDTTYLogger.sharedInstance.colorsEnabled = true
		DDTTYLogger.sharedInstance.setForegroundColor(UIColor.lightGray, backgroundColor: nil, for: DDLogFlag.verbose)
		DDTTYLogger.sharedInstance.setForegroundColor(UIColor.darkGray, backgroundColor: nil, for: DDLogFlag.debug)
		DDTTYLogger.sharedInstance.setForegroundColor(UIColor.black, backgroundColor: nil, for: DDLogFlag.info)
		DDTTYLogger.sharedInstance.setForegroundColor(UIColor.orange, backgroundColor: nil, for: DDLogFlag.warning)
		DDTTYLogger.sharedInstance.setForegroundColor(UIColor.red, backgroundColor: nil, for: DDLogFlag.error)
	}

	/**
	 A debug message to log.

	 This message will only be logged when in debug mode, not in a release version.

	 Use this type of log for development purposes, e.g. for finding bugs, printing states, etc.
	 Normally after developing the feature all of those debug logs have to be removed to not clutter the console with not used messages,
	 but some may be useful for any debug session so they can be left in place.

	 - parameter message: The message to log.
	 - parameter file: The file name where the log has been called. Don't provide a value, will be automatically set.
	 - parameter function: The function name where the log has been called. Don't provide a value, will be automatically set.
	 - parameter line: The line in the code file where the log has been called. Don't provide a value, will be automatically set.
	 */
	static func debug(
		_ message: @autoclosure () -> String,
		file: StaticString = #file,
		function: StaticString = #function,
		line: UInt = #line
	) {
		DDLogDebug(
			message,
			context: 0,
			file: file,
			function: function,
			line: line,
			tag: nil,
			asynchronous: true,
			ddlog: DDLog.sharedInstance
		)
	}

	/**
	 An info message to log.

	 **This message will also be logged in a release version.**

	 Use this type of log to track the app's usage by the user so each step can be reproduced by the log.

	 - parameter message: The message to log.
	 - parameter file: The file name where the log has been called. Don't provide a value, will be automatically set.
	 - parameter function: The function name where the log has been called. Don't provide a value, will be automatically set.
	 - parameter line: The line in the code file where the log has been called. Don't provide a value, will be automatically set.
	 */
	static func info(
		_ message: @autoclosure () -> String,
		file: StaticString = #file,
		function: StaticString = #function,
		line: UInt = #line
	) {
		DDLogInfo(
			message,
			context: 0,
			file: file,
			function: function,
			line: line,
			tag: nil,
			asynchronous: true,
			ddlog: DDLog.sharedInstance
		)
	}

	/**
	 A warning message to log.

	 **This message will always be logged, even in a release version.**

	 Use this type of log when a recoverable error occured, e.g. a method call returns with an error and this case is gracefully treated,
	 but it may be useful to log the returned error message.
	 So the app won't crash or end in an undefined state and can continue, but the step hasn't passed as desired.

	 - parameter message: The message to log.
	 - parameter file: The file name where the log has been called. Don't provide a value, will be automatically set.
	 - parameter function: The function name where the log has been called. Don't provide a value, will be automatically set.
	 - parameter line: The line in the code file where the log has been called. Don't provide a value, will be automatically set.
	 */
	static func warn(
		_ message: @autoclosure () -> String,
		file: StaticString = #file,
		function: StaticString = #function,
		line: UInt = #line
	) {
		DDLogWarn(
			message,
			context: 0,
			file: file,
			function: function,
			line: line,
			tag: nil,
			asynchronous: false,
			ddlog: DDLog.sharedInstance
		)
	}

	/**
	 An error message to log.

	 **This message will always be logged, even in a release version.**

	 Use this type of log when a critical error occured and the app might crash or gets into an undefined state.
	 Normally you don't need to log something in such a case, because you always use `fatalError` or `precondition` instead,
	 so in an ideal world this log should not be needed and never happen...

	 - parameter message: The message to log.
	 - parameter file: The file name where the log has been called. Don't provide a value, will be automatically set.
	 - parameter function: The function name where the log has been called. Don't provide a value, will be automatically set.
	 - parameter line: The line in the code file where the log has been called. Don't provide a value, will be automatically set.
	 */
	static func error(
		_ message: @autoclosure () -> String,
		file: StaticString = #file,
		function: StaticString = #function,
		line: UInt = #line
	) {
		DDLogError(
			message,
			context: 0,
			file: file,
			function: function,
			line: line,
			tag: nil,
			asynchronous: false,
			ddlog: DDLog.sharedInstance
		)
	}
}
