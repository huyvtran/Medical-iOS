import Foundation

extension Bundle {
	/// Returns the app version number (`CFBundleShortVersionString`), e.g.: "1.0".
	var versionNumber: String {
		return object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? String.empty
	}

	/// Returns the app build number (`CFBundleVersion`), e.g.: "42".
	var buildNumber: String {
		return object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? String.empty
	}
}
