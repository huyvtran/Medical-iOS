import Foundation
import RealmSwift
import Timepiece
import UserNotifications

class NotificationWorker: NSObject {
	/// Apple's user notification center to deliver local notifications.
	private let notificationCenter = UNUserNotificationCenter.current()

	/// The prefix string for all local notification IDs.
	private static let localNotificationPrefixId = "MakulaReminder"

	/**
	 Initializes the worker.
	 Has to be done before the app has launched because the worker registers itself as a delegate to the notification center.
	 */
	override init() {
		super.init()

		notificationCenter.delegate = self
	}

	/// Whether the app has asked the user for authorization.
	var authorizationRequested = false

	/// Whether the user has authorized the app to use notifications.
	var isAuthorized = false
}

// MARK: - NotificationWorkerInterface

extension NotificationWorker: NotificationWorkerInterface {
	/**
	 Updates the authorisation status. While this is happening the flag `authorisationStatusPending` is `true`.
	 As soon as it gets `false` the status values are read and assigned.

	 Should be called when the app gets to the foreground because the status might have been changed by the user.

	 - completionHandler: Callback which will be called when the update has completed.
	 Returns a reference to this worker which flags have been updated.
	 */
	func updateAuthorisationStatus(completionHandler: @escaping (NotificationWorkerInterface) -> Void) {
		return notificationCenter.getNotificationSettings(completionHandler: { [weak self] settings in
			guard let strongSelf = self else { return }

			switch settings.authorizationStatus {
			case .notDetermined:
				strongSelf.authorizationRequested = false
				strongSelf.isAuthorized = false
			case .denied:
				strongSelf.authorizationRequested = true
				strongSelf.isAuthorized = false
			case .authorized:
				strongSelf.authorizationRequested = true
				strongSelf.isAuthorized = true
			case .provisional:
				strongSelf.authorizationRequested = true
				strongSelf.isAuthorized = true
			}

			completionHandler(strongSelf)
		})
	}

	/**
	 Requests for authorization to send local notifications.
	 Has to be called when authorization has not yet requested.

	 - completionHandler: Callback gets called when the request has completed.
	 Returns a reference to this worker which flags have been updated.
	 */
	func requestAuthorization(completionHandler: @escaping (NotificationWorkerInterface) -> Void) {
		precondition(!authorizationRequested)

		notificationCenter.requestAuthorization(options: [.alert, .sound]) { [weak self] granted, error in
			guard let strongSelf = self else { return }

			strongSelf.authorizationRequested = error == nil
			strongSelf.isAuthorized = granted
			completionHandler(strongSelf)
		}
	}

	/**
	 Cancels any pending notifications. Should be called before creating and enqueuing new notifications.
	 */
	func cancelAllNotificationRequests() {
		notificationCenter.removeAllPendingNotificationRequests()
	}

	/**
	 Enqueues a new local notification.

	 - parameter identifier: A unique identifier for the requested notification.
	 - parameter title: The notification's display title.
	 - parameter message: The notification's body text.
	 - parameter date: The fire date when to show the notification.
	 */
	func addNotification(identifier: String, title: String, message: String, date: Date) {
		let notification = UNMutableNotificationContent()
		notification.title = title
		notification.body = message
		notification.sound = UNNotificationSound.default
		let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
		let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
		let request = UNNotificationRequest(identifier: identifier, content: notification, trigger: trigger)
		notificationCenter.add(request)
	}

	/**
	 Deletes old and creates new local notification requests for the appointments if necessary.
	 Does nothing if not authorized.

	 - parameter internalSettings: The internal settings to determine if notifications are activated and when.
	 - parameter dataModelManager: The data model manager to retrieve the appointments.
	 */
	func setupLocalNotifications(internalSettings: InternalSettingsInterface, dataModelManager: DataModelManagerInterface) {
		// Update the status.
		updateAuthorisationStatus { strongSelf in
			// Only proceed if authorization has been requested and granted.
			guard strongSelf.authorizationRequested else { return }
			guard strongSelf.isAuthorized else { return }

			// Cancel old notification requests.
			strongSelf.cancelAllNotificationRequests()

			// Skip if the user didn't activate reminders.
			guard internalSettings.reminderOn else { return }

			// Retrieve all future appointments.
			let currentDate = Date()
			guard let appointments = dataModelManager.getAppointments(after: currentDate) else { return }

			// Go through all appointments to make notifications for them.
			for appointment in appointments {
				let identifier = NotificationWorker.localNotificationPrefixId + String(appointment.type.rawValue) + appointment.date.description
				let title = appointment.type.nameString()
				let dateString = CommonDateFormatter.formattedTimeString(date: appointment.date)
				let message = R.string.global.localNotificationMessage(dateString)
				guard let fireDate = appointment.date - internalSettings.reminderTime.minutes else { fatalError() }
				strongSelf.addNotification(identifier: identifier, title: title, message: message, date: fireDate)
			}
		}
	}
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationWorker: UNUserNotificationCenterDelegate {
	func userNotificationCenter(_ center: UNUserNotificationCenter,
	                            willPresent notification: UNNotification,
	                            withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler([.alert, .sound])
	}
}
