import RealmSwift

/**
 The app's data model manager which manages any data hold in the database.

 Uses a Realm database, see docu:

 - [https://www.realm.io/docs/swift/latest/](https://www.realm.io/docs/swift/latest/)
 - [https://realm.io/docs/swift/3.6.0/api/index.html](https://realm.io/docs/swift/3.6.0/api/index.html)
 */
protocol DataModelManagerInterface {
	// MARK: - Init

	/// The default Realm configuration used for all database connections.
	var defaultConfiguration: Realm.Configuration { get }

	/**
	 Tries to establish a connection to the database in the background asynchronously.
	 Creates the database with default values or migrates it when necessary.
	 This should be the first call to happen before calling any other method.

	 When command line arguments are provided and they include the `testMode` then the database will be prepared according to the test scenario.
	 See `Const.TestArgument` for possible arguments to pass.

	 - parameter testScenario: The test scenario to use when the app is in test mode.
	 - parameter handler: The closure which will be called to inform about the current state or result of this call.
	 Might be called multiple times, but will always be on the main thread.
	 - parameter state: The current state of the background process.
	 */
	func touchDatabase(testScenario: Const.TestArgument.Scenario?, handler: @escaping (_ state: DataModelTouchState) -> Void)

	// MARK: - Write

	/**
	 Performs any changes to the database (e.g. deletion of objects) or their objects (e.g. modifying).

	 **Only change any properties of model objects within an operations closure of this write call.**

	 This should only be used by protocol extensions which should provide a cleaner interface to the real operation.

	 - parameter operations: The closure with all write operations to apply to the database.
	 - parameter realm: A reference to the realm database currently writing to, e.g. for adding or deleting objects.
	 - returns: `true` if the write operation was successful, otherwise `false` when something went wrong.
	 */
	func write(operations: (_ realm: Realm) throws -> Void) -> Bool

	/**
	 Performs any changes to the database (e.g. deletion of objects) or their objects (e.g. modifying) in a background thread.

	 **Only change any properties of model objects within an operations closure of a write call.**

	 This should only be used by protocol extensions which should provide a cleaner interface to the real operation.

	 - parameter operations: The closure with all write operations to apply to the database.
	 - parameter realm: A reference to the realm database currently writing to, e.g. for adding or deleting objects.
	 */
	func backgroundWrite(operations: @escaping (_ realm: Realm) throws -> Void)

	/**
	 Exports the database as a backup zip file.
	 Make sure no database connection is open at the time.

	 - parameter completionHandler: The completion handler called on the main thread when the data is ready.
	 - data: The zipped database.
	 */
	func exportData(completionHandler: @escaping (_ data: Data?) -> Void)

	/**
	 Imports a zipped backup file by unzipping the database and replacing the current one in the app with
	 the newly extracted one.
	 This happens in immediately on the main thread.
	 Make sure the app refreshes afterwards.

	 - parameter url: The URL to the zip file.
	 - returns: Whether importing succeeded or not.
	 */
	func importData(atUrl url: URL) -> Bool
}

/// The states for touching the database.
enum DataModelTouchState {
	/// Database needs to be migrated which will be started now. Another state will follow.
	case beginMigration
	/// The process has finished and the database is ready to use.
	case finished
	/// While creating the initial database or determining the schema version an error occurred.
	case initError
	/// While migrating the database an error occurred.
	case migrationError
}
