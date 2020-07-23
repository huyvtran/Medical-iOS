/// The router interface provided to the logic to make all possible routes from this scene to others available.
protocol CalendarRouterInterface: class {
	/**
	 Routes back to the previous scene on the navigation stack.
	 */
	func routeBack()

	/**
	 Routes to the new appointment scene.

	 - parameter model: The model for set up the destination scene.
	 */
	func routeToNewAppointment(model: NewAppointmentRouterModel.Setup)

	/**
	 Routes to the appointment detail scene.

	 - parameter model: The model for set up the destination scene.
	 */
	func routeToAppointmentDetail(model: AppointmentDetailRouterModel.Setup)
}
