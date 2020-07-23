import Anchorage
import UIKit

class SplitCell: BaseCell {
	// MARK: - Init

	public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .default, reuseIdentifier: reuseIdentifier)
		configureView()
	}

	// MARK: - View configuration

	/// The cell's view.
	private let cellView = SplitCellView()

	/**
	 Sets up the view hierarchy and layout.
	 */
	private func configureView() {
		// Embed the view into this cell.
		contentView.addSubview(cellView)
		cellView.edgeAnchors == contentView.edgeAnchors

		// Disable visible selection.
		selectionStyle = .none
	}

	// MARK: - Setup

	/// The cell's model.
	private var model: SplitCellModel?

	/**
	 Sets up the cell.

	 - parameter model: The cell's model.
	 */
	func setup(model: SplitCellModel) {
		// Apply model.
		self.model = model
		cellView.leftTitle = model.leftTitle
		cellView.rightTitle = model.rightTitle
		cellView.leftSelected = model.leftSelected
		cellView.rightSelected = model.rightSelected
		cellView.backColor = model.backgroundColor
		cellView.separatorColor = model.separatorColor
		cellView.largeStyle = model.largeStyle
		cellView.isEnabled = !model.disabled
		isUserInteractionEnabled = !model.disabled

		// Register for callback actions
		cellView.onLeftTitleButtonPressed.setDelegate(to: self, with: { strongSelf, _ in
			model.delegate?.leftButtonPressed(onSplitCell: strongSelf)
		})
		cellView.onRightTitleButtonPressed.setDelegate(to: self, with: { strongSelf, _ in
			model.delegate?.rightButtonPressed(onSplitCell: strongSelf)
		})
	}

	// MARK: - Colorizing

	/**
	 Resume the color of the views after speaking in speech mode.
	 */

	func applyDefaultColor() {
		guard let model = model else { return }

		cellView.leftSelected = model.leftSelected
		cellView.rightSelected = model.rightSelected
	}

	/**
	 Sets the highlight color of views while speaking in speech mode.
	 */

	func applyHighlightColor() {
		cellView.leftSelected = true
		cellView.rightSelected = true
	}

	// MARK: - Cell highlight

	override func setSelected(_ selected: Bool, animated: Bool) {
		// Apply colors according to speaking state.
		if selected {
			applyHighlightColor()
		} else {
			applyDefaultColor()
		}
	}
}
