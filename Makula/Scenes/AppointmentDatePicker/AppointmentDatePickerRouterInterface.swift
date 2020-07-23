/// The router interface provided to the logic to make all possible routes from this scene to others available.
protocol AppointmentDatePickerRouterInterface: class {
	/**
	 Routes back to the new appointment scene on the navigation stack.
	 */
	func routeBackToNewAppointment()

	/**
	 Routes to the calendar scene by manipulating the navigation stack.

	 - parameter model: The model for scene setup.
	 */
	func routeToCalendar(model: CalendarRouterModel.Setup)
}
