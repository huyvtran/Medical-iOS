import Timepiece
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
class GraphLogic {
	// MARK: - Dependencies

	/// A weak reference to the display.
	private weak var display: GraphDisplayInterface?

	/// The strong reference to the router.
	private let router: GraphRouterInterface

	/// The data model holding the current scene state.
	var contentData = GraphLogicModel.ContentData()

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
	init(display: GraphDisplayInterface, router: GraphRouterInterface) {
		self.display = display
		self.router = router
	}
}

// MARK: - GraphLogicInterface

extension GraphLogic: GraphLogicInterface {
	// MARK: - Models

	func setModel(_ model: GraphRouterModel.Setup) {
		contentData = GraphLogicModel.ContentData()
		contentData.globalData = model.globalData
		contentData.eyeType = model.eyeType
	}

	// MARK: - Requests

	func requestDisplayData() {
		// Graph's start and end date.
		let today = Date()
		let endDate = (today.startOfMonth() + 1.month)!
		let startDate = (endDate - Int(Const.Graph.Value.xAxisSteps).months)!

		// Get the models.
		var nhdModels = [NhdModel]()
		if let models = globalData.dataModelManager.getNhdModels(from: startDate, to: endDate) {
			nhdModels = Array(models)
		}
		var visusModels = [VisusModel]()
		if let models = globalData.dataModelManager.getVisusModels(from: startDate, to: endDate) {
			visusModels = Array(models)
		}
		let lastTreatmentModel = globalData.dataModelManager.getLastTreatmentModel(upTo: today)

		// Prepare display model.
		let isLandscape = isDeviceOrientationLandscape()
		let displayModel = GraphDisplayModel.UpdateDisplay(
			largeStyle: isLandscape,
			eyeType: contentData.eyeType,
			ivomDate: lastTreatmentModel?.date,
			nhdModels: nhdModels,
			visusModels: visusModels
		)
		display?.updateDisplay(model: displayModel)
	}

	// MARK: - Actions

	func backButtonPressed() {
		router.routeBack()
	}

	func leftEyeSelected() {
		guard contentData.eyeType != .left else { return }
		contentData.eyeType = .left
		requestDisplayData()
	}

	func rightEyeSelected() {
		guard contentData.eyeType != .right else { return }
		contentData.eyeType = .right
		requestDisplayData()
	}
}
