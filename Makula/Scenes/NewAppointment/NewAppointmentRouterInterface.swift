/// The router interface provided to the logic to make all possible routes from this scene to others available.
protocol NewAppointmentRouterInterface: class {
	/**
	 Routes back to the previous menu scene on the navigation stack.
	 */
	func routeBack()

	/**
	 Routes to the medicament scene by pushing it onto the navigation stack.

	 - parameter model: The model for setup the medicament scene.
	 */
	func routeToDatePicker(model: AppointmentDatePickerRouterModel.Setup)
}
