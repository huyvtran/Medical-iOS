import Foundation

extension Const {
	/// Notification constants for this project.
	struct Notification {
		/// Custom notification names to use for sending notifications through the app.
		struct Name {
			/// Informs that the app's internal settings have been changed.
			/// Provides a `userInfo` dictionary as parameter.
			static let InternalSettingsDidChange = Foundation.Notification.Name("INDInternalSettingsDidChangeNotification")
		}

		/// Keys for a notification `userInfo` dictionary. The key's name begins with the notification's name for which it is.
		struct UserInfoKey {
			// MARK: - InternalSettingsDidChange

			/// Key for the type of internal setting which has been changed.
			/// Value is a `Const.InternalSetting.Key` element.
			static let InternalSettingsDidChangeSettingKey = "InternalSettingsDidChangeSettingKey"
		}
	}
}
