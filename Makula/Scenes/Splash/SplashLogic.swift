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
class SplashLogic {
	// MARK: - Dependencies

	/// A weak reference to the display.
	private weak var display: SplashDisplayInterface?

	/// The strong reference to the router.
	private let router: SplashRouterInterface

	/// The data model holding the current scene state.
	var contentData = SplashLogicModel.ContentData()

	/// The global data from the content data.
	private var globalData: GlobalData {
		guard let globalData = contentData.globalData else { fatalError() }
		return globalData
	}

	// MARK: - Init

	/**
	 Sets up the instance with references.

	 - parameter display: The reference to the display, hold weakly.
	 - parameter router: The reference to the router, hold strongly.
	 */
	init(display: SplashDisplayInterface, router: SplashRouterInterface) {
		self.display = display
		self.router = router
	}

	// MARK: - Timed transition

	/// Flag which indicates when the data update process has finished.
	private var dataUpdateFinished = false
	/// Flag which indicates when the timer has fired.
	private var timerFinished = false

	/**
	 Processes the transition if all conditions for it are met, which is all sub-processes have finished
	 like the min delay timer and the data update.
	 Does nothing if the conditions have not yet been met.
	 */
	private func processTransition() {
		// Wait for all conditions to be met.
		guard dataUpdateFinished && timerFinished else {
			// Not all sub-processes have finished.
			return
		}

		// Update local notifications.
		globalData.notificationWorker.setupLocalNotifications(
			internalSettings: globalData.internalSettings,
			dataModelManager: globalData.dataModelManager
		)

		// Perform scene transition.
		let settings = globalData.internalSettings
		if settings.disclaimerAccepted {
			// Transition to the home menu.
			let model = MenuRouterModel.Setup(globalData: globalData, sceneId: .home)
			router.routeToMenu(model: model)
		} else {
			// Transition to the disclaimer scene.
			let model = DisclaimerRouterModel.Setup(globalData: globalData)
			router.routeToDisclaimer(model: model)
		}
	}
}

// MARK: - SplashLogicInterface

extension SplashLogic: SplashLogicInterface {
	// MARK: - Models

	func setModel(_ model: SplashRouterModel.Setup) {
		contentData = SplashLogicModel.ContentData()
		contentData.globalData = model.globalData
		contentData.commandLineArguments = model.commandLineArguments
	}

	// MARK: - Requests

	func requestDisplayData() {
		let displayModel = SplashDisplayModel.UpdateDisplay()
		display?.updateDisplay(model: displayModel)
	}

	// MARK: - Trigger

	func processForTransition() {
		// Start min delay timer.
		DispatchQueue.main.asyncAfter(deadline: .now() + Const.Splash.Time.transitionDelay) { [weak self] in
			guard let strongSelf = self else { return }

			// Finish timer.
			strongSelf.timerFinished = true
			strongSelf.processTransition()
		}

		let testScenario = Const.TestArgument.Scenario(commandLineArguments: contentData.commandLineArguments)

		// Update the app's internal settings if needed.
		guard let internalSettings = contentData.globalData?.internalSettings else { fatalError() }
		internalSettings.updateSettings(testScenario: testScenario)

		// Touch the app's database and update it if needed.
		guard let dataModelManager = contentData.globalData?.dataModelManager else { fatalError() }
		dataModelManager.touchDatabase(testScenario: testScenario) { [weak self] state in
			guard let strongSelf = self else { return }

			switch state {
			case .beginMigration:
				// Not used, yet.
				break
			case .finished:
				// Continue with transition.
				strongSelf.dataUpdateFinished = true
				strongSelf.processTransition()
			case .initError, .migrationError:
				// Inform user about failure.
				strongSelf.display?.showDatabaseError()
			}
		}
	}
}
