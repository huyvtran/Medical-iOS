import Foundation
import RealmSwift
import Timepiece
import Zip

class DataModelManager {
	// MARK: - Properties

	/// The default Realm configuration to use for all database connections.
	lazy var defaultConfiguration: Realm.Configuration = {
		Realm.Configuration(
			fileURL: Const.DataModelManager.databaseFileUrl,
			encryptionKey: nil,
			schemaVersion: Const.DataModelManager.latestVersionNumber,
			migrationBlock: nil
		)
	}()

	// MARK: - Init

	/**
	 Initializes the manager.
	 */
	init() {}

	// MARK: - Deletion

	/**
	 Deletes the database by removing all files from disk.

	 For this to work the database and all its objects must be released so no reference is allowed to live anymore.
	 This is rarely possible after accessing the database before, except for when using `autoreleasepool` for limited usage.
	 See also: [https://realm.io/docs/swift/latest#deleting-realm-files](https://realm.io/docs/swift/latest#deleting-realm-files)
	 */
	func deleteDatabase() {
		// Get path to the database and its auxiliary files.
		guard let realmURL = defaultConfiguration.fileURL else { fatalError() }
		let realmURLs = [
			realmURL,
			realmURL.appendingPathExtension("lock"),
			realmURL.appendingPathExtension("note"),
			realmURL.appendingPathExtension("management")
		]

		// Delete all path references to only remove the files leaving the folder as it is.
		for url in realmURLs {
			try? FileManager.default.removeItem(at: url)
		}
	}

	/**
	 Deletes all the objects from the database without deleting the files from disk.

	 This should be preferred over `deleteDatabase` because this shouldn't fail when there are still objects referenced somewhere,
	 they just get invalidated.
	 */
	func clearDatabase() {
		do {
			let realm = try Realm(configuration: defaultConfiguration)
			try realm.write {
				realm.deleteAll()
			}
		} catch let error {
			Log.warn("Failed to clear the database: \(error)")
		}
	}
}

// MARK: - DataModelManagerInterface

extension DataModelManager: DataModelManagerInterface {
	// MARK: - Init

	func touchDatabase(testScenario: Const.TestArgument.Scenario? = nil, handler: @escaping (_ state: DataModelTouchState) -> Void) {
		// Make sure the folder exists.
		do {
			try FileManager.default.createDirectory(at: Const.DataModelManager.databaseFolderUrl, withIntermediateDirectories: true, attributes: nil)
		} catch let error {
			Log.error("Database folder couldn't be created: \(error)")
			fatalError()
		}

		let configuration = defaultConfiguration
		let migrationBlock: MigrationBlock

		// Apply test scenario if any is provided.
		if let testScenario = testScenario {
			#if DEBUG
				// Delete the database and assign a migration block according to the scenario.
				deleteDatabase()
				migrationBlock = DataModelMigration.migrationBlock(testScenario: testScenario)
			#else
				fatalError("'testMode' not supported in release version")
			#endif
		} else {
			// Not in test mode, use default migration.
			migrationBlock = DataModelMigration.defaultMigrationBlock
		}

		DispatchQueue.global(qos: .background).async {
			// Create database with no schema version if there is no database present, yet.
			if !FileManager.default.fileExists(atPath: Const.DataModelManager.databaseFileUrl.path) {
				var initialConfiguration = configuration
				initialConfiguration.schemaVersion = 0
				initialConfiguration.migrationBlock = nil
				do {
					try autoreleasepool {
						_ = try Realm(configuration: initialConfiguration)
					}
				} catch let error {
					Log.warn("Init DB error: \(error)")
					DispatchQueue.main.async {
						handler(.initError)
					}
					return
				}
			}

			// Determine if migration is necessary.
			if configuration.inMemoryIdentifier == nil {
				// Schema version can only be determined for non-memory databases.
				do {
					try autoreleasepool {
						let currentVersion = try schemaVersionAtURL(Const.DataModelManager.databaseFileUrl)
						if currentVersion < Const.DataModelManager.latestVersionNumber {
							// Migration needed for sure, inform about it.
							DispatchQueue.main.async {
								handler(.beginMigration)
							}
						}
					}
				} catch let error {
					Log.warn("Version check error: \(error)")
					DispatchQueue.main.async {
						handler(.migrationError)
					}
					return
				}
			}

			// Now try connect the database and migrate to the newest version if necessary.
			var migrationConfiguration = configuration
			migrationConfiguration.schemaVersion = Const.DataModelManager.latestVersionNumber
			migrationConfiguration.migrationBlock = migrationBlock
			do {
				try autoreleasepool {
					_ = try Realm(configuration: migrationConfiguration)
				}
			} catch let error {
				Log.warn("Touching Realm failed: \(error)")
				DispatchQueue.main.async {
					handler(.migrationError)
				}
				return
			}

			// Inform about migration end.
			DispatchQueue.main.async {
				handler(.finished)
			}
		}
	}

	// MARK: - Write

	func write(operations: (_ realm: Realm) throws -> Void) -> Bool {
		do {
			let realm = try Realm(configuration: defaultConfiguration)
			try realm.write {
				try operations(realm)
			}
		} catch let error {
			Log.warn("Realm write error: \(error)")
			return false
		}
		return true
	}

	func backgroundWrite(operations: @escaping (_ realm: Realm) throws -> Void) {
		let configurations = defaultConfiguration
		DispatchQueue.global().async {
			autoreleasepool {
				do {
					let realm = try Realm(configuration: configurations)
					try realm.write {
						try operations(realm)
					}
				} catch let error {
					Log.warn("Realm background write error: \(error)")
				}
			}
		}
	}

	// MARK: - Backup

	func exportData(completionHandler: @escaping (_ data: Data?) -> Void) {
		let configuration = defaultConfiguration

		// Process the export in the background.
		DispatchQueue.global().async {
			let databaseUrl = Const.DataModelManager.databaseFileUrl
			let zipUrl = Const.DataModelManager.backupFileUrl
			var data: Data?

			// Make sure the backup folder exists.
			do {
				try FileManager.default.createDirectory(at: Const.DataModelManager.backupFolderUrl, withIntermediateDirectories: true, attributes: nil)
			} catch let error {
				Log.error("Backup folder couldn't be created: \(error)")
				fatalError()
			}

			// Make sure no other process is trying to write at the moment of the backup by requesting write access.
			do {
				try autoreleasepool {
					let realm = try Realm(configuration: configuration)
					try realm.write {
						// Instead of writing to the database we zip it.
						Log.debug("Exporting realm: \(databaseUrl.absoluteString)")
						try Zip.zipFiles(paths: [databaseUrl], zipFilePath: zipUrl, password: nil, progress: nil)
						Log.debug("Realm zipped: \(zipUrl.absoluteString)")

						// Read the zip file into memory.
						data = try Data(contentsOf: zipUrl)

						// Cleanup by deleting the backup folder on disk.
						try FileManager.default.removeItem(at: Const.DataModelManager.backupFolderUrl)

						// Rollback the write process.
						realm.cancelWrite()
					}
				}
			} catch let error {
				Log.warn("Exporting Realm failed: \(error)")
				DispatchQueue.main.async {
					completionHandler(nil)
				}
				return
			}

			// Deliver data via callback on the main thread.
			DispatchQueue.main.async {
				completionHandler(data)
			}
		}
	}

	func importData(atUrl url: URL) -> Bool {
		let backupFolder = Const.DataModelManager.backupFolderUrl
		defer {
			do {
				// Cleanup by deleting the backup folder on disk.
				try FileManager.default.removeItem(at: backupFolder)
			} catch {}
		}

		// Make sure the backup folder exists.
		do {
			try FileManager.default.createDirectory(at: backupFolder, withIntermediateDirectories: true, attributes: nil)
		} catch let error {
			Log.error("Backup folder couldn't be created: \(error)")
			fatalError()
		}

		// Copy the backup file into the backup folder because we can't open it right in place.
		let backupFileUrl = backupFolder.appendingPathComponent("archive.zip")
		do {
			try FileManager.default.copyItem(at: url, to: backupFileUrl)
		} catch let error {
			Log.error("Copying the backup file failed \(error)")
			return false
		}

		// Extract the backup file to the backup folder.
		do {
			try Zip.unzipFile(backupFileUrl, destination: backupFolder, overwrite: true, password: nil)
		} catch let error {
			Log.warn("Failed to unzip backup: \(error)")
			return false
		}

		// Delete the backup archive.
		do {
			try FileManager.default.removeItem(at: backupFileUrl)
		} catch {
			Log.warn("Failed deleting the backup file: \(error)")
			fatalError()
		}

		// Try touching the extracted backup database.
		let configuration = Realm.Configuration(
			fileURL: backupFolder.appendingPathComponent(Const.DataModelManager.databaseFileName),
			encryptionKey: nil,
			schemaVersion: Const.DataModelManager.latestVersionNumber,
			migrationBlock: DataModelMigration.defaultMigrationBlock
		)
		do {
			try autoreleasepool {
				_ = try Realm(configuration: configuration)
			}
		} catch let error {
			Log.warn("Touching backup Realm failed: \(error)")
			return false
		}

		// Backup seems valid, replace current database with backup.
		let databaseFolder = Const.DataModelManager.databaseFolderUrl
		do {
			// Remove current version.
			try FileManager.default.removeItem(at: databaseFolder)
			// Rename backup path.
			try FileManager.default.moveItem(at: backupFolder, to: databaseFolder)
		} catch let error {
			Log.error("Replacing database with backup failed \(error)")
			return false
		}

		return true
	}
}
