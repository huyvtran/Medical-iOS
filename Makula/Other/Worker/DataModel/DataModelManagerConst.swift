import AppFolder

extension Const {
	/// Constants for the data model manager.
	struct DataModelManager {
		/// The folder path where to save the database files to (must be a subfolder explicit for the database).
		static let databaseFolderUrl = AppFolder.Documents.Database.url

		/// The file name of the database on disc.
		static let databaseFileName = "default.realm"

		/// The folder path to the database file.
		static let databaseFileUrl = databaseFolderUrl.appendingPathComponent(databaseFileName)

		/// The folder path where to manage a backup.
		static let backupFolderUrl = AppFolder.Documents.Backup.url

		/// The folder path to the zipped database file during backup.
		static let backupFileUrl = backupFolderUrl.appendingPathComponent("archive.zip")

		/// The data model version number for app v1.0.
		static let modelVersion1: UInt64 = 1

		/// The latest version number to which the data base should be updated.
		/// Assign new value when a new model version is introduced.
		static let latestVersionNumber = modelVersion1
	}
}
