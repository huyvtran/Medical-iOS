import UIKit

/**
 The logic class of this scene.

 This class is responsible for any logic happening in the scene, all possible states and the data models.
 It is NOT responsible for any presentation, this is what the display is for.
 This class also doesn't need to provide each logic, it may divide it into worker classes.
 The logic functions as the glue between all workers and the display.
 The logic holds all data models necessary to work on in this scene and if needed it provides the data for routing purposes.
 All routings have to be executed via the logic, but be done by the router class which is hold by the logic.
 */
class ReadingTestLogic {
	// MARK: - Dependencies

	/// A weak reference to the display.
	private weak var display: ReadingTestDisplayInterface?

	/// The strong reference to the router.
	private let router: ReadingTestRouterInterface

	/// The data model holding the current scene state.
	var contentData = ReadingTestLogicModel.ContentData()

	/// The global data from the content data.
	private var globalData: GlobalData {
		guard let globalData = contentData.globalData else { fatalError() }
		return globalData
	}

	/// A closure which returns true when the device is currently in landscape otherwise false.
	/// Defaultly this returns `UIDevice.current.orientation.isLandscape`.
	var isDeviceOrientationLandscape: () -> Bool = {
		UIDevice.current.orientation.isLandscape
	}

	// MARK: - Init

	/**
	 Sets up the instance with references.

	 - parameter display: The reference to the display, hold weakly.
	 - parameter router: The reference to the router, hold strongly.
	 */
	init(display: ReadingTestDisplayInterface, router: ReadingTestRouterInterface) {
		self.display = display
		self.router = router
	}
}

// MARK: - ReadingTestLogicInterface

extension ReadingTestLogic: ReadingTestLogicInterface {
	// MARK: - Models

	func setModel(_ model: ReadingTestRouterModel.Setup) {
		contentData = ReadingTestLogicModel.ContentData()
		contentData.globalData = model.globalData
	}

	// MARK: - Requests

	func requestDisplayData() {
		// Get model.
		if contentData.readingTestModel == nil {
			let today = Date()
			guard let modelResults = globalData.dataModelManager.getReadingtestModel(forDay: today) else { fatalError() }
			if let model = modelResults.first {
				// Found an existing model for the day.
				contentData.readingTestModel = model
			} else {
				// No model for the day, create one temporarily.
				contentData.readingTestModel = globalData.dataModelManager.createReadingTestModel(date: today)
			}
		}

		// Update display.
		let largeStyle = isDeviceOrientationLandscape()
		let displayModel = ReadingTestDisplayModel.UpdateDisplay(
			largeStyle: largeStyle,
			readingTestModel: contentData.readingTestModel,
			dataModelManager: globalData.dataModelManager
		)
		display?.updateDisplay(model: displayModel)
	}

	func databaseWriteError() {
		display?.showDatabaseWriteError()
	}

	// MARK: - Actions

	func backButtonPressed() {
		// Delete an empty data model.
		if let model = contentData.readingTestModel, model.magnitudeLeft == nil, model.magnitudeRight == nil {
			if !globalData.dataModelManager.deleteReadingTestModel(model) {
				Log.warn("Deleting an empty readingtest model failed")
			}
			contentData.readingTestModel = nil
		}

		// Route back.
		router.routeBackToMenu()
	}

	func infoButtonPressed() {
		// Perform route.
		let model = InfoRouterModel.Setup(globalData: globalData, sceneType: .readingtest)
		router.routeToInformation(model: model)
	}
}
