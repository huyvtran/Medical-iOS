import RealmSwift
import Timepiece

extension DataModelManagerInterface {
	/**
	 Retrieves the amslertest models (should be one at most) for a specific day.

	 - parameter date: The day for which to retrieve the entry. The hours will be stripped off for the search.
	 - returns: The model.
	 */
	func getAmslertestModel(forDay date: Date) -> Results<AmslertestModel>? {
		guard let startDate = date.truncated(from: .hour) else { fatalError() }
		guard let endDate = startDate + 1.day else { fatalError() }

		do {
			let realm = try Realm(configuration: defaultConfiguration)
			let models = realm.objects(AmslertestModel.self).filter("date >= %@ AND date < %@", startDate, endDate)
			return models
		} catch let error {
			Log.warn("Realm error: \(error)")
			return nil
		}
	}

	/**
	 Creates and adds a new amslertest model to the database in the current thread.

	 - parameter date: The date for when the model gets saved.
	 - returns: The created model.
	 */
	func createAmslertestModel(date: Date) -> AmslertestModel? {
		// Create model.
		let model = AmslertestModel()
		model.date = date

		// Save model to database.
		guard write(operations: { realm in
			realm.add(model)
		}) else {
			return nil
		}

		return model
	}

	/**
	 Deletes an amslertest model.

	 - parameter model: The model to delete.
	 - returns: `true` if deleting was successful, otherwise `false`.
	 */
	func deleteAmslertestModel(_ model: AmslertestModel) -> Bool {
		return write { realm in
			realm.delete(model)
		}
	}

	/**
	 Updates an existing amslertest model to set the left progress.

	 - parameter model: The model to update.
	 - parameter progressLeft: The value for the left eye progress.
	 - returns: Whether writing was successfull or not.
	 */
	func updateAmslertestModel(_ model: AmslertestModel, progressLeft: AmslertestProgressType?) -> Bool {
		return write { _ in
			model.progressLeft = progressLeft
		}
	}

	/**
	 Updates an existing amslertest model to set the right progress.

	 - parameter model: The model to update.
	 - parameter progressRight: The value for the right eye progress.
	 - returns: Whether writing was successfull or not.
	 */
	func updateAmslertestModel(_ model: AmslertestModel, progressRight: AmslertestProgressType?) -> Bool {
		return write { _ in
			model.progressRight = progressRight
		}
	}
}
