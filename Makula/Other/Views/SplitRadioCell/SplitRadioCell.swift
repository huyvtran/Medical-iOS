import Anchorage
import UIKit

class SplitRadioCell: BaseCell {
	// MARK: - Init

	public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .default, reuseIdentifier: reuseIdentifier)
		configureView()
	}

	// MARK: - View configuration

	/// The cell's view.
	private let cellView = SplitRadioCellView()

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
	private var model: SplitRadioCellModel?

	/**
	 Sets up the cell.

	 - parameter model: The cell's model.
	 */
	func setup(model: SplitRadioCellModel) {
		// Apply model.
		self.model = model
		cellView.title = model.title
		cellView.largeStyle = model.largeStyle
		cellView.leftSelected = model.leftSelected
		cellView.rightSelected = model.rightSelected
		cellView.isEnabled = !model.disabled
		isUserInteractionEnabled = !model.disabled

		// Register for callback actions
		cellView.onLeftButtonPressed.setDelegate(to: self, with: { strongSelf, _ in
			model.delegate?.leftButtonPressed(onSplitRadioCell: strongSelf, indexPath: model.indexPath)
		})
		cellView.onRightButtonPressed.setDelegate(to: self, with: { strongSelf, _ in
			model.delegate?.rightButtonPressed(onSplitRadioCell: strongSelf, indexPath: model.indexPath)
		})
	}

	// MARK: - Cell highlight

	override func setSelected(_ selected: Bool, animated: Bool) {
		// Apply colors according to speaking state.
		cellView.isSpeechHighlighted = selected
	}
}
