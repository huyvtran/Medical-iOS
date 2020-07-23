import UIKit

extension UIFont {
	/**
	 On iOS 11 creates a font from this which uses the dynamic font size (for `headline`) to scale.
	 On iOS 10 or less this method just returns this font.

	 When appliying this font to a label also make sure the label's `adjustsFontForContentSizeCategory` is set to `true`.

	 - returns: The font which can be used for dynamic font sizing.
	 */
	func dynamicallyScaled() -> UIFont {
		if #available(iOS 11.0, *) {
			// Use a dynamic font size.
			let fontMetrics = UIFontMetrics(forTextStyle: .headline)
			return fontMetrics.scaledFont(for: self)
		} else {
			// Fallback uses a static font size.
			return self
		}
	}
}
