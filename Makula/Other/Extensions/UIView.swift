import Anchorage
import UIKit

extension UIView {
	// MARK: - Constructors

	/**
	 Creates and returns a new UIView with its background color set.

	 - parameter color: The view's new background color.
	 - returns: The new view.
	 */
	static func viewWithColor(_ color: UIColor) -> UIView {
		let view = UIView()
		view.backgroundColor = color
		return view
	}

	// MARK: - Layer manipulation

	/// The view layer's corner radius.
	@IBInspectable public var cornerRadius: CGFloat {
		get { return layer.cornerRadius }
		set { layer.cornerRadius = newValue }
	}

	/// The view layer's boder width.
	@IBInspectable public var borderWidth: CGFloat {
		get { return layer.borderWidth }
		set { layer.borderWidth = newValue }
	}

	/// The view layer's border color.
	@IBInspectable public var borderColor: UIColor {
		get { return UIColor(cgColor: layer.borderColor!) }
		set { layer.borderColor = newValue.cgColor }
	}

	/// The view layer's mask to bounds flag.
	@IBInspectable public var masksToBounds: Bool {
		get { return layer.masksToBounds }
		set { layer.masksToBounds = newValue }
	}

	// MARK: - Compression resistance & content hugging

	/// The content compression resistance priority for the horizontal axis.
	var horizontalCompressionResistance: Priority {
		get {
			return Priority(contentCompressionResistancePriority(for: .horizontal).rawValue)
		}
		set {
			setContentCompressionResistancePriority(newValue.value, for: .horizontal)
		}
	}

	/// The content compression resistance priority for the vertical axis.
	var verticalCompressionResistance: Priority {
		get {
			return Priority(contentCompressionResistancePriority(for: .vertical).rawValue)
		}
		set {
			setContentCompressionResistancePriority(newValue.value, for: .vertical)
		}
	}

	/// The content hugging priority for the horizontal axis.
	var horizontalHuggingPriority: Priority {
		get {
			return Priority(contentHuggingPriority(for: .horizontal).rawValue)
		}
		set {
			setContentHuggingPriority(newValue.value, for: .horizontal)
		}
	}

	/// The content hugging priority for the vertical axis.
	var verticalHuggingPriority: Priority {
		get {
			return Priority(contentHuggingPriority(for: .vertical).rawValue)
		}
		set {
			setContentHuggingPriority(newValue.value, for: .vertical)
		}
	}
}
