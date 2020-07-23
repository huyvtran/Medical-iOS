/// The router interface provided to the logic to make all possible routes from this scene to others available.
protocol ReminderRouterInterface: class {
	/**
	 Routes back to the previous scene on the navigation stack.
	 */
	func routeBack()
}
