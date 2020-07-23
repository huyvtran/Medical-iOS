extension Const {
	/// Constants for the internal settings.
	struct InternalSettings {
		/// The latest version number to which the internal settings should be updated.
		/// Assign new value when a new settings version is introduced.
		static let LatestVersionNumber = SettingsVersion1

		/// The internal settings version number for app v1.0.
		static let SettingsVersion1 = 1

		/// Any setting keys used for saving and retrieving values to and from the user defaults.
		struct Key: Hashable, Equatable, RawRepresentable, ExpressibleByStringLiteral {
			// MARK: - Setting keys

			/// The setting's version (integer) for versioning the settings.
			static let SettingsVersion: Key = "SettingsUserDefaultsKeySettingsVersion"

			/// The flag (boolean) which indicates whether the disclaimer has been accepted by the user.
			static let DisclaimerAccepted: Key = "SettingsUserDefaultsKeyDisclaimerAccepted"

			/// The flag (boolean) which indicates whether the reminder for appointments is on.
			static let AppointmentReminder: Key = "SettingsUserDefaultsKeyAppointmentReminder"

			/// The value (integer) of the appointment reminder time in minutes.
			static let AppointmentReminderTime: Key = "SettingsUserDefaultsKeyAppointmentReminderTime"

			// MARK: - Key implementation

			/// The raw string value of the key.
			var rawValue: String

			init(rawValue: String) {
				self.rawValue = rawValue
			}

			init(stringLiteral value: String) {
				rawValue = value
			}

			// MARK: Equality

			static func == (lhs: Key, rhs: Key) -> Bool {
				return lhs.rawValue == rhs.rawValue
			}

			static func == (lhs: String, rhs: Key) -> Bool {
				return lhs == rhs.rawValue
			}

			static func == (lhs: Key, rhs: String) -> Bool {
				return lhs.rawValue == rhs
			}

			static func ~= (pattern: String, value: Key) -> Bool {
				return pattern == value
			}

			static func ~= (pattern: Key, value: String) -> Bool {
				return pattern == value
			}
		}
	}
}
