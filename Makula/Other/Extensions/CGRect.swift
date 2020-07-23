import UIKit

extension CGRect {
	/// Provides a rect with the greatest finite magnitude for the width and height.
	/// As a workaround for iOS 10 use this for initializing any views in code otherwise the `layoutMargins` doesn't work.
	static var max: CGRect {
		return CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
	}
}
