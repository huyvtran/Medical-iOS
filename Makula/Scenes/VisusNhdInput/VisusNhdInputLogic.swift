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
class VisusNhdInputLogic {
	// MARK: - Dependencies

	/// A weak reference to the display.
	private weak var display: VisusNhdInputDisplayInterface?

	/// The strong reference to the router.
	private let router: VisusNhdInputRouterInterface

	/// The data model holding the current scene state.
	var contentData = VisusNhdInputLogicModel.ContentData()

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
	init(display: VisusNhdInputDisplayInterface, router: VisusNhdInputRouterInterface) {
		self.display = display
		self.router = router
	}
}

// MARK: - VisusNhdInputLogicInterface

extension VisusNhdInputLogic: VisusNhdInputLogicInterface {
	// MARK: - Models

	func setModel(_ model: VisusNhdInputRouterModel.Setup) {
		contentData = VisusNhdInputLogicModel.ContentData()
		contentData.globalData = model.globalData
		contentData.sceneType = model.sceneType

		// Retrieve existing data for today.
		let today = Date()
		let dataModelManager = model.globalData.dataModelManager
		switch model.sceneType {
		case .visus:
			let results = dataModelManager.getVisusModels(forDay: today)
			if let existingEntry = results?.first {
				contentData.leftValue = Float(existingEntry.valueLeft)
				contentData.rightValue = Float(existingEntry.valueRight)
			}
		case .nhd:
			let results = dataModelManager.getNhdModels(forDay: today)
			if let existingEntry = results?.first {
				contentData.leftValue = existingEntry.valueLeft
				contentData.rightValue = existingEntry.valueRight
			}
		}

		if contentData.leftValue == nil && contentData.rightValue == nil {
			// Preselect the value with the middle of possible values.
			let sceneType = model.sceneType
			contentData.leftValue = sceneType.middleValue
			contentData.leftSelected = true
			contentData.rightSelected = false
		}
	}

	// MARK: - Requests

	func requestDisplayData() {
		guard let sceneType = contentData.sceneType else { fatalError() }
		let largeStyle = isDeviceOrientationLandscape()
		let displayModel = VisusNhdInputDisplayModel.UpdateDisplay(
			largeStyle: largeStyle,
			sceneType: sceneType,
			leftSelected: contentData.leftSelected,
			rightSelected: contentData.rightSelected,
			leftValue: contentData.leftValue,
			rightValue: contentData.rightValue
		)
		display?.updateDisplay(model: displayModel)
	}

	func databaseWriteError() {
		display?.showDatabaseWriteError()
	}

	// MARK: - Actions

	func backButtonPressed() {
		router.routeBack()
	}

	func infoButtonPressed() {
		guard let sceneType = contentData.sceneType else { fatalError() }

		let infoType: InfoType
		switch sceneType {
		case .visus:
			infoType = .visus
		case .nhd:
			infoType = .nhd
		}

		// Perform route.
		let model = InfoRouterModel.Setup(globalData: globalData, sceneType: infoType)
		router.routeToInformation(model: model)
	}

	func confirmButtonPressed() {
		guard let sceneType = contentData.sceneType else { fatalError() }
		guard let dataModelManager = contentData.globalData?.dataModelManager else { fatalError() }
		guard let leftValue = contentData.leftValue else { fatalError() }
		guard let rightValue = contentData.rightValue else { fatalError() }

		// Save data.
		let today = Date()
		switch sceneType {
		case .visus:
			let results = dataModelManager.getVisusModels(forDay: today)
			let leftValueInt = Int(leftValue)
			let rightValueInt = Int(rightValue)
			if let existingEntry = results?.first {
				// Update existing entry.
				if !dataModelManager.updateVisusModel(existingEntry, date: today, valueLeft: leftValueInt, valueRight: rightValueInt) {
					databaseWriteError()
					return
				}
			} else {
				// Create new entry.
				dataModelManager.createVisusModel(date: today, valueLeft: leftValueInt, valueRight: rightValueInt)
			}
		case .nhd:
			let results = dataModelManager.getNhdModels(forDay: today)
			if let existingEntry = results?.first {
				// Update existing entry.
				if !dataModelManager.updateNhdModel(existingEntry, date: today, valueLeft: leftValue, valueRight: rightValue) {
					databaseWriteError()
					return
				}
			} else {
				// Create new entry.
				dataModelManager.createNhdModel(date: today, valueLeft: leftValue, valueRight: rightValue)
			}
		}

		// Route to the graph.
		let routerModel = GraphRouterModel.Setup(
			globalData: globalData,
			modifyNavigationStack: true,
			eyeType: .left
		)
		router.routeToGraph(model: routerModel)
	}

	func leftEyeSelected() {
		guard let sceneType = contentData.sceneType else { fatalError() }

		if contentData.leftValue == nil {
			// Preselect the value with the middle of possible values.
			contentData.leftValue = sceneType.middleValue
		}
		if contentData.rightValue != nil && contentData.leftValue != nil {
			// Both values have data, enable confirm button in display.
			display?.enableConfirmButton()
		}
		contentData.leftSelected = true
		contentData.rightSelected = false
		requestDisplayData()
	}

	func rightEyeSelected() {
		guard let sceneType = contentData.sceneType else { fatalError() }

		if contentData.rightValue == nil {
			// Preselect the value with the middle of possible values.
			contentData.rightValue = sceneType.middleValue
		}
		if contentData.rightValue != nil && contentData.leftValue != nil {
			// Both values have data, enable confirm button in display.
			display?.enableConfirmButton()
		}
		contentData.leftSelected = false
		contentData.rightSelected = true
		requestDisplayData()
	}

	func valueChanged(newValue: Float) {
		if contentData.leftSelected {
			contentData.leftValue = newValue
		} else if contentData.rightSelected {
			contentData.rightValue = newValue
		} else {
			fatalError()
		}
		display?.updateValueTitle(model: VisusNhdInputDisplayModel.UpdateValueTitle(
			leftValue: contentData.leftValue,
			rightValue: contentData.rightValue
		))
	}
}
