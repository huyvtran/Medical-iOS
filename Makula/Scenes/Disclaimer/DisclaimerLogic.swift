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
class DisclaimerLogic {
	// MARK: - Dependencies

	/// A weak reference to the display.
	private weak var display: DisclaimerDisplayInterface?

	/// The strong reference to the router.
	private let router: DisclaimerRouterInterface

	/// The data model holding the current scene state.
	var contentData = DisclaimerLogicModel.ContentData()

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
	init(display: DisclaimerDisplayInterface, router: DisclaimerRouterInterface) {
		self.display = display
		self.router = router
	}
}

// MARK: - DisclaimerLogicInterface

extension DisclaimerLogic: DisclaimerLogicInterface {
	// MARK: - Models

	func setModel(_ model: DisclaimerRouterModel.Setup) {
		contentData = DisclaimerLogicModel.ContentData()
		contentData.globalData = model.globalData
	}

	// MARK: - Requests

	func requestDisplayData() {
		let isLandscape = isDeviceOrientationLandscape()
		let displayModel = DisclaimerDisplayModel.UpdateDisplay(largeStyle: isLandscape)
		display?.updateDisplay(model: displayModel)
	}

	// MARK: - Actions

	func confirmButtonPressed() {
		guard contentData.disclaimerConfirmed else {
			// Disclaimer not confirmed.
			return
		}
		// Update setting
		globalData.internalSettings.disclaimerAccepted = contentData.disclaimerConfirmed

		// Transition to the home menu.
		let model = MenuRouterModel.Setup(globalData: globalData, sceneId: .home)
		router.routeToMenu(model: model)
	}

	func checkboxButtonStateChanged(checked: Bool) {
		contentData.disclaimerConfirmed = checked
		display?.updateConfirmButton(enabled: checked)
	}
}
