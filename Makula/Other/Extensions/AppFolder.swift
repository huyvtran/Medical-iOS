import AppFolder

// swiftlint:disable identifier_name
extension Documents {
	// MARK: - AppFolder.Documents.Database

	final class Database: Directory {}

	var Database: Database {
		return subdirectory()
	}

	// MARK: - AppFolder.Documents.Backup

	final class Backup: Directory {}

	/// Makes available: `AppFolder.Documents.Backup`
	var Backup: Backup {
		return subdirectory()
	}
}
