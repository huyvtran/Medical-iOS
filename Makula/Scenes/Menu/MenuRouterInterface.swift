/// The router interface provided to the logic to make all possible routes from this scene to others available.
protocol MenuRouterInterface: class {
	/**
	 Routes to the menu scene by pushing the new sub-menu scene onto the navigation stack.

	 - parameter model: The model for scene setup.
	 */
	func routeToMenu(model: MenuRouterModel.Setup)

	/**
	 Routes to the new appointment scene by pushing it onto the navigation stack.

	 - parameter model: The model for scene setup.
	 */
	func routeToNewAppointment(model: NewAppointmentRouterModel.Setup)

	/**
	 Routes to the contact scene by pushing it onto the navigation stack.

	 - parameter model: The model for scene setup.
	 */
	func routeToContact(model: ContactRouterModel.Setup)

	/**
	 Routes to the diagnosis scene by pushing it onto the navigation stack.

	 - parameter model: The model for scene setup.
	 */
	func routeToDiagnosis(model: DiagnosisRouterModel.Setup)

	/**
	 Routes to the medicament scene by pushing it onto the navigation stack.

	 - parameter model: The model for scene setup.
	 */
	func routeToMedicament(model: MedicamentRouterModel.Setup)

	/**
	 Routes to the visus NHD input scene by pushing it onto the navigation stack.

	 - parameter model: The model for scene setup.
	 */
	func routeToVisusNhdInput(model: VisusNhdInputRouterModel.Setup)

	/**
	 Routes to the calendar scene by pushing it onto the navigation stack.

	 - parameter model: The model for scene setup.
	 */
	func routeToCalendar(model: CalendarRouterModel.Setup)

	/**
	 Routes to the amslertest scene by pushing it onto the navigation stack.

	 - parameter model: The model for scene setup.
	 */
	func routeToAmslertest(model: AmslertestRouterModel.Setup)

	/**
	 Routes to the reading test scene by pushing it onto the navigation stack.

	 - parameter model: The model for scene setup.
	 */
	func routeToReadingTest(model: ReadingTestRouterModel.Setup)

	/**
	 Routes to the graph scene by pushing it onto the navigation stack.

	 - parameter model: The model for scene setup.
	 */
	func routeToGraph(model: GraphRouterModel.Setup)

	/**
	 Routes to the appointment detail scene.

	 - parameter model: The model for set up the destination scene.
	 */
	func routeToAppointmentDetail(model: AppointmentDetailRouterModel.Setup)

	/**
	 Routes to the information scene by pushing it onto the navigation stack.

	 - parameter model: The model for scene setup.
	 */
	func routeToInformation(model: InfoRouterModel.Setup)

	/**
	 Routes to the search scene by pushing it onto the navigation stack.

	 - parameter model: The model for scene setup.
	 */
	func routeToSearch(model: SearchRouterModel.Setup)

	/**
	 Routes to the reminder scene by pushing it onto the navigation stack.

	 - parameter model: The model for scene setup.
	 */
	func routeToReminder(model: ReminderRouterModel.Setup)

	/**
	 Routes back to the previous menu scene on the navigation stack.
	 */
	func routeBackToMenu()
}
