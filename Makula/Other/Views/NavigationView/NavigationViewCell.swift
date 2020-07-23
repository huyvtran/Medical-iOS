import Anchorage
import UIKit

class NavigationViewCell: BaseCell {
	// MARK: - Init

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .default, reuseIdentifier: reuseIdentifier)
		configureView()
	}

	// MARK: - View configuration

	/// The cell's main view.
	private let navigationView = NavigationView()

	/**
	 Sets up the view hierarchy and layout.
	 */
	private func configureView() {
		// Embed the main view into this cell.
		contentView.addSubview(navigationView)
		navigationView.edgeAnchors == contentView.edgeAnchors

		// Disable visible selection.
		selectionStyle = .none
		navigationView.leftButtonType = .back
		navigationView.rightButtonType = .speaker
	}

	// MARK: - Setup

	/**
	 Sets up the cell.

	 - parameter model: The cell's model.
	 */
	func setup(model: NavigationViewCellModel) {
		// Apply model.
		navigationView.title = model.title
		navigationView.titleColor = model.color
		navigationView.largeStyle = model.largeStyle
		navigationView.separatorVisible = model.separatorVisible
		navigationView.leftButtonVisible = model.leftButtonVisible
		if let type = model.leftButtonType {
			navigationView.leftButtonType = type
		}
		navigationView.rightButtonVisible = model.rightButtonVisible
		if let type = model.rightButtonType {
			navigationView.rightButtonType = type
		}

		// Register for callback actions
		navigationView.onLeftButtonPressed.setDelegate(to: self, with: { strongSelf, _ in
			model.delegate?.leftButtonPressed(onNavigationViewCell: strongSelf)
		})
		navigationView.onRightButtonPressed.setDelegate(to: self, with: { strongSelf, _ in
			model.delegate?.rightButtonPressed(onNavigationViewCell: strongSelf)
		})
	}
}
