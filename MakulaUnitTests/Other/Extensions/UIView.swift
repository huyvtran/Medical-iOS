import UIKit

extension UIView {
	/**
	 Adds a constraint to the view which defines a fixed width.

	 - parameter width: The width the view should get.
	 */
	func addWidthConstraint(withWidth width: CGFloat) {
		addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width))
	}

	/**
	 Adds a constraint to the view which defines a fixed height.

	 - parameter height: The height the view should get.
	 */
	func addHeightConstraint(withHeight height: CGFloat) {
		addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height))
	}
}
