import Foundation

protocol NotificationWorkerInterface {
	/// Whether the app has asked the user for authorization.
	var authorizationRequested: Bool { get }

	/// Whether the user has authorized the app to use notifications.
	var isAuthorized: Bool { get }

	/**
	 Updates the authorisation status. While this is happening the flag `authorisationStatusPending` is `true`.
	 As soon as it gets `false` the status values are read and assigned.

	 Should be called when the app gets to the foreground because the status might have been changed by the user.

	 - completionHandler: Callback which will be called when the update has completed.
	 Returns a reference to this worker which flags have been updated.
	 */
	func updateAuthorisationStatus(completionHandler: @escaping (NotificationWorkerInterface) -> Void)

	/**
	 Requests for authorization to send local notifications.
	 Has to be called when authorization has not yet requested.

	 - completionHandler: Callback gets called when the request has completed.
	 Returns a reference to this worker which flags have been updated.
	 */
	func requestAuthorization(completionHandler: @escaping (NotificationWorkerInterface) -> Void)

	/**
	 Cancels any pending notifications. Should be called before creating and enqueuing new notifications.
	 */
	func cancelAllNotificationRequests()

	/**
	 Enqueues a new local notification.

	 - parameter identifier: A unique identifier for the requested notification.
	 - parameter title: The notification's display title.
	 - parameter message: The notification's body text.
	 - parameter date: The fire date when to show the notification.
	 */
	func addNotification(identifier: String, title: String, message: String, date: Date)

	/**
	 Deletes old and creates new local notification requests for the appointments if necessary.
	 Does nothing if not authorized.

	 - parameter internalSettings: The internal settings to determine if notifications are activated and when.
	 - parameter dataModelManager: The data model manager to retrieve the appointments.
	 */
	func setupLocalNotifications(internalSettings: InternalSettingsInterface, dataModelManager: DataModelManagerInterface)
}
