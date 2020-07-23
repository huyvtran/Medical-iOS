import RealmSwift
import Timepiece

/**
 The migration possibilities for a Realm database version upgrade.
 */
class DataModelMigration {
	// MARK: - Default migration

	/// The migration block which transforms the database from one version to the most recent one.
	static let defaultMigrationBlock: MigrationBlock = { migration, oldSchemaVersion in
		Log.info("Migrating DB from \(oldSchemaVersion) to \(Const.DataModelManager.latestVersionNumber)")

		if oldSchemaVersion < Const.DataModelManager.modelVersion1 {
			// Add default diagnosis objects.
			migration.create(DiagnosisModel.className(), value: ["type": DiagnosisType.amd.rawValue, "sortOrderPosition": DiagnosisType.amd.rawValue])
			migration.create(DiagnosisModel.className(), value: ["type": DiagnosisType.dmo.rawValue, "sortOrderPosition": DiagnosisType.dmo.rawValue])
			migration.create(DiagnosisModel.className(), value: ["type": DiagnosisType.rvv.rawValue, "sortOrderPosition": DiagnosisType.rvv.rawValue])
			migration.create(DiagnosisModel.className(), value: ["type": DiagnosisType.mcnv.rawValue, "sortOrderPosition": DiagnosisType.mcnv.rawValue])

			// Add default medicament objects.
			let medicamentDate = Date(year: 2018, month: 6, day: 1, hour: 0, minute: 0, second: 0)
			migration.create(MedicamentModel.className(), value: [
				"name": R.string.global.medicamentEntryAvastin(),
				"editable": false,
				"creationDate": (medicamentDate + 1.minute)!
			])
			migration.create(MedicamentModel.className(), value: [
				"name": R.string.global.medicamentEntryEylea(),
				"editable": false,
				"creationDate": (medicamentDate + 2.minute)!
			])
			migration.create(MedicamentModel.className(), value: [
				"name": R.string.global.medicamentEntryLucentis(),
				"editable": false,
				"creationDate": (medicamentDate + 3.minute)!
			])
			migration.create(MedicamentModel.className(), value: [
				"name": R.string.global.medicamentEntryOzurdex(),
				"editable": false,
				"creationDate": (medicamentDate + 4.minute)!
			])
			migration.create(MedicamentModel.className(), value: [
				"name": R.string.global.medicamentEntryIluvien(),
				"editable": false,
				"creationDate": (medicamentDate + 5.minute)!
			])

			// Add default contact objects.
			let contactDate = Date(year: 2018, month: 6, day: 1, hour: 0, minute: 0, second: 0)
			migration.create(ContactModel.className(), value: [
				"type": ContactType.treatment.rawValue,
				"creationDate": (contactDate + 1.minute)!
			])
			migration.create(ContactModel.className(), value: [
				"type": ContactType.aftercare.rawValue,
				"creationDate": (contactDate + 2.minute)!
			])
			migration.create(ContactModel.className(), value: [
				"type": ContactType.octCheck.rawValue,
				"creationDate": (contactDate + 3.minute)!
			])
			migration.create(ContactModel.className(), value: [
				"type": ContactType.amdNet.rawValue,
				"creationDate": (contactDate + 4.minute)!,
				"name": "AMD-Netz e.V.",
				"mobile": "",
				"phone": "01805774778",
				"email": "info@amd-netz.de",
				"web": "www.amd-netz.de",
				"street": "Hohenzollernring 56",
				"city": "48145 Münster"
			])
		}
	}

	// MARK: - Test scenarios

	#if DEBUG

		/**
		 Returns a migration block used for a given test scenario. Only valid when in debug mode.

		 - parameter testScenario: The current test scenario to apply.
		 - returns: A migration block.
		 */
		static func migrationBlock(testScenario: Const.TestArgument.Scenario) -> MigrationBlock {
			switch testScenario {
			case .none:
				// No test scenario, use default migration.
				return defaultMigrationBlock
			case .startedOnce:
				return startedOnceMigrationBlock
			case .appUsed:
				return appUsedMigrationBlock
			case .screenshots:
				return screenshotMigrationBlock
			}
		}

		private static var startedOnceMigrationBlock: MigrationBlock {
			// Nothing special to change, just use the default data.
			return DataModelMigration.defaultMigrationBlock
		}

		private static var appUsedMigrationBlock: MigrationBlock {
			return { migration, oldSchemeVersion in
				// Apply the default data before adding custom data.
				DataModelMigration.defaultMigrationBlock(migration, oldSchemeVersion)

				// Add some custom medicaments.
				let medicamentDate = Date(year: 2018, month: 7, day: 1, hour: 0, minute: 0, second: 0)
				migration.create(MedicamentModel.className(), value: [
					"name": "My custom med 1",
					"editable": true,
					"creationDate": (medicamentDate + 1.second)!
				])
				migration.create(MedicamentModel.className(), value: [
					"name": "Another custom medicament with a longer title",
					"editable": true,
					"creationDate": (medicamentDate + 2.seconds)!
				])

				// Add custom contacts.
				let contactDate = Date(year: 2018, month: 7, day: 1, hour: 0, minute: 0, second: 0)
				migration.create(ContactModel.className(), value: [
					"type": ContactType.custom.rawValue,
					"creationDate": (contactDate + 1.seconds)!,
					"name": "My buddy",
					"mobile": "0179 555 55 55 55",
					"phone": "555 55 55 55",
					"email": "mail@trash.me",
					"web": "google.de",
					"street": "Streetname",
					"city": "Cityname"
				])

				// Add some appointments.
				migration.create(AppointmentModel.className(), value: [
					"type": AppointmentType.treatment.rawValue,
					"date": Date(year: 2018, month: 6, day: 1, hour: 18, minute: 20, second: 0)
				])
				migration.create(AppointmentModel.className(), value: [
					"type": AppointmentType.treatment.rawValue,
					"date": Date(year: 2018, month: 6, day: 2, hour: 0, minute: 0, second: 0)
				])
				migration.create(AppointmentModel.className(), value: [
					"type": AppointmentType.treatment.rawValue,
					"date": Date(year: 2018, month: 3, day: 15, hour: 0, minute: 0, second: 0)
				])
				migration.create(AppointmentModel.className(), value: [
					"type": AppointmentType.aftercare.rawValue,
					"date": Date(year: 2018, month: 6, day: 1, hour: 8, minute: 30, second: 0)
				])
				migration.create(AppointmentModel.className(), value: [
					"type": AppointmentType.aftercare.rawValue,
					"date": Date(year: 2018, month: 6, day: 3, hour: 0, minute: 0, second: 0)
				])
				migration.create(AppointmentModel.className(), value: [
					"type": AppointmentType.octCheck.rawValue,
					"date": Date(year: 2018, month: 6, day: 1, hour: 12, minute: 50, second: 0)
				])
				migration.create(AppointmentModel.className(), value: [
					"type": AppointmentType.octCheck.rawValue,
					"date": Date(year: 2018, month: 6, day: 4, hour: 0, minute: 0, second: 0)
				])
				migration.create(AppointmentModel.className(), value: [
					"type": AppointmentType.other.rawValue,
					"date": Date(year: 2018, month: 6, day: 1, hour: 15, minute: 11, second: 0)
				])
				migration.create(AppointmentModel.className(), value: [
					"type": AppointmentType.other.rawValue,
					"date": Date(year: 2018, month: 6, day: 5, hour: 0, minute: 0, second: 0)
				])

				// Add some NHD values.
				migration.create(NhdModel.className(), value: [
					"valueLeft": 300,
					"valueRight": 360,
					"date": Date(year: 2018, month: 2, day: 1, hour: 0, minute: 0, second: 0)
				])
				migration.create(NhdModel.className(), value: [
					"valueLeft": 320,
					"valueRight": 260,
					"date": Date(year: 2018, month: 2, day: 15, hour: 0, minute: 0, second: 0)
				])
				migration.create(NhdModel.className(), value: [
					"valueLeft": 340,
					"valueRight": 260,
					"date": Date(year: 2018, month: 5, day: 1, hour: 0, minute: 0, second: 0)
				])
				migration.create(NhdModel.className(), value: [
					"valueLeft": 280,
					"valueRight": 310,
					"date": Date(year: 2018, month: 6, day: 1, hour: 0, minute: 0, second: 0)
				])
				migration.create(NhdModel.className(), value: [
					"valueLeft": 300,
					"valueRight": 280,
					"date": Date(year: 2018, month: 7, day: 1, hour: 0, minute: 0, second: 0)
				])

				// Add some Visus values.
				migration.create(VisusModel.className(), value: [
					"valueLeft": 11,
					"valueRight": 0,
					"date": Date(year: 2017, month: 8, day: 1, hour: 0, minute: 0, second: 0)
				])
				migration.create(VisusModel.className(), value: [
					"valueLeft": 5,
					"valueRight": 4,
					"date": Date(year: 2018, month: 6, day: 1, hour: 13, minute: 2, second: 0)
				])
				migration.create(VisusModel.className(), value: [
					"valueLeft": 3,
					"valueRight": 12,
					"date": Date(year: 2018, month: 8, day: 1, hour: 1, minute: 2, second: 0)
				])

				// Add Amslertest.
				migration.create(AmslertestModel.className(), value: [
					"progressLeftValue": AmslertestProgressType.better.rawValue,
					"progressRightValue": AmslertestProgressType.worse.rawValue,
					"date": Date(year: 2018, month: 6, day: 1, hour: 14, minute: 22, second: 47)
				])
				migration.create(AmslertestModel.className(), value: [
					"progressLeftValue": AmslertestProgressType.better.rawValue,
					"progressRightValue": AmslertestProgressType.worse.rawValue,
					"date": Date(year: 2018, month: 5, day: 6, hour: 14, minute: 22, second: 47)
				])

				// Add readingtest.
				migration.create(ReadingTestModel.className(), value: [
					"magnitudeLeftValue": ReadingTestMagnitudeType.big.rawValue,
					"magnitudeRightValue": ReadingTestMagnitudeType.little.rawValue,
					"date": Date(year: 2018, month: 6, day: 1, hour: 14, minute: 23, second: 30)
				])
				migration.create(ReadingTestModel.className(), value: [
					"magnitudeLeftValue": ReadingTestMagnitudeType.big.rawValue,
					"magnitudeRightValue": ReadingTestMagnitudeType.little.rawValue,
					"date": Date(year: 2018, month: 5, day: 7, hour: 14, minute: 23, second: 30)
				])

				// Add notes.
				migration.create(NoteModel.className(), value: [
					"date": Date(year: 2018, month: 6, day: 1, hour: 13, minute: 2, second: 0),
					"content": "A custom note"
				])
				migration.create(NoteModel.className(), value: [
					"date": Date(year: 2018, month: 6, day: 13, hour: 13, minute: 2, second: 0),
					// swiftlint:disable:next line_length
					"content": "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."
				])
			}
		}

		private static var screenshotMigrationBlock: MigrationBlock {
			return { migration, oldSchemeVersion in
				// Apply the default data before adding custom data.
				DataModelMigration.defaultMigrationBlock(migration, oldSchemeVersion)

				// Add some appointments.
				let today = Date()
				let day1 = today.changed(day: 14)!
				migration.create(AppointmentModel.className(), value: [
					"type": AppointmentType.treatment.rawValue,
					"date": day1
				])
				let day2 = today.changed(day: 21)!
				migration.create(AppointmentModel.className(), value: [
					"type": AppointmentType.aftercare.rawValue,
					"date": day2
				])
				let day3 = (today.changed(day: 4)! + 1.months)!
				migration.create(AppointmentModel.className(), value: [
					"type": AppointmentType.octCheck.rawValue,
					"date": day3
				])

				// Add notes.
				let day4 = today.changed(day: 4)!
				migration.create(NoteModel.className(), value: [
					"date": day4,
					"content": "A note"
				])
				let day5 = today.changed(day: 19)!
				migration.create(NoteModel.className(), value: [
					"date": day5,
					"content": "A note"
				])
				let day6 = (today.changed(day: 5)! + 1.months)!
				migration.create(NoteModel.className(), value: [
					"date": day6,
					"content": "A note"
				])
			}
		}
	#endif
}
