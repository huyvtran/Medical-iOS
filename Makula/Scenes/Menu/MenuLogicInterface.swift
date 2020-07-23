import Foundation

/// The logic interface, which is available to the display for starting logic work.
protocol MenuLogicInterface: class {
	// MARK: - Models

	/**
	 Assigns the setup model for the initial state.

	 - parameter model: The model.
	 */
	func setModel(_ model: MenuRouterModel.Setup)

	/**
	 Assigns the speech data.

	 - parameter data: The speech data.
	 */
	func setSpeechData(data: [SpeechData])

	// MARK: - Requests

	/**
	 Requests the current display data to show.

	 Will immediately call `updateDisplay(model:)` on the display to return the requested data.
	 */
	func requestDisplayData()

	// MARK: - Actions

	/**
	 Informs that the user has pressed the back button.

	 Routes back to the previous scene.
	 */
	func backButtonPressed()

	/**
	 Informs that the user has pressed the speak button.

	 This will start the speech reading the scene's text.
	 If the button is hit while a previous speech is currently in progress the speech will be stopped instead.
	 */
	func speakButtonPressed()

	// MARK: - Routings

	/**
	 Routes to the menu scene (either `doctorVisit` or `selfTest`).

	 - parameter sceneId: The scene's ID to which to transition.
	 */
	func routeToMenu(sceneId: SceneId)

	/**
	 Routes to the new appointment scene.
	 */
	func routeToNewAppointment()

	/**
	 Routes to the contact scene.
	 */
	func routeToContact()

	/**
	 Routes to the medicament scene.
	 */
	func routeToMedicament()

	/**
	 Routes to the diagnosis scene.
	 */
	func routeToDiagnosis()

	/**
	 Routes to the visus NHD input scene.

	 - parameter type: Which scene's type.
	 */
	func routeToVisusNhdInput(type: VisusNhdType)

	/**
	 Routes to the calendar scene.
	 */
	func routeToCalendar()

	/**
	 Routes to the Amslertest scene.
	 */
	func routeToAmslertest()

	/**
	 Routes to the reading test scene.
	 */
	func routeToReadingTest()

	/**
	 Routes to the graph scene.
	 */
	func routeToGraph()

	/**
	 Routes to the appointment detail scene.

	 - parameter date: The date to show the details for.
	 */
	func routeToAppointmentDetail(date: Date)

	/**
	 Routes to the info scene for a specific type.

	 - parameter infoType: The type of information which should be displayed.
	 */
	func routeToInfo(infoType: InfoType)

	/**
	 Routes to the search scene.
	 */
	func routeToSearch()

	/**
	 Routes to the reminder scene.
	 */
	func routeToReminder()
}
