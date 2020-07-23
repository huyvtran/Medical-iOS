import RealmSwift
import Timepiece

extension DataModelManagerInterface {
	/**
	 Deletes all data related to a day, which are all appointments and all associated data inclusive the note.

	 - parameter date: The date on which to delete all data.
	 */
	@discardableResult
	func deleteData(forDay date: Date) -> Bool {
		guard let startDate = date.truncated(from: .hour) else { fatalError() }
		guard let endDate = startDate + 1.day else { fatalError() }

		do {
			let realm = try Realm(configuration: defaultConfiguration)

			let appointments = realm.objects(AppointmentModel.self).filter("date >= %@ AND date < %@", startDate, endDate)
			let amslertests = realm.objects(AmslertestModel.self).filter("date >= %@ AND date < %@", startDate, endDate)
			let readingtest = realm.objects(ReadingTestModel.self).filter("date >= %@ AND date < %@", startDate, endDate)
			let visus = realm.objects(VisusModel.self).filter("date >= %@ AND date < %@", startDate, endDate)
			let nhd = realm.objects(NhdModel.self).filter("date >= %@ AND date < %@", startDate, endDate)
			let notes = realm.objects(NoteModel.self).filter("date >= %@ AND date < %@", startDate, endDate)

			try realm.write {
				realm.delete(appointments)
				realm.delete(amslertests)
				realm.delete(readingtest)
				realm.delete(visus)
				realm.delete(nhd)
				realm.delete(notes)
			}
		} catch let error {
			Log.warn("Realm error: \(error)")
			return false
		}
		return true
	}
}
