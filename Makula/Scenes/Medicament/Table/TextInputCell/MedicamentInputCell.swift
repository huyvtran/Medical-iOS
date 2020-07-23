import Anchorage
import UIKit

class MedicamentInputCell: BaseCell {
	// MARK: - Init

	public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configureView()
	}

	// MARK: - View configuration

	/// The cell's main view.
	private let cellView = MedicamentInputCellView()

	/**
	 Sets up the view hierarchy and layout.
	 */
	private func configureView() {
		// Embed the main view into this cell.
		contentView.addSubview(cellView)
		cellView.edgeAnchors == contentView.edgeAnchors
		selectionStyle = .none
	}

	// MARK: - Setup

	/**
	 Sets up the cell.

	 - parameter model: The cell's model.
	 */
	func setup(model: MedicamentInputCellModel) {
		// Apply model.
		cellView.largeStyle = model.largeStyle
		cellView.textFieldDelegate = model.delegate
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		if selected {
			cellView.makeTextFieldFirstResponder()
		}
	}

	// MARK: - Cell highlight

	/**
	 Highlights/De-highlights the text for the speech in the cell.

	 - parameter highlighted: The highlight state. `true` to highlight, `false` to de-highlight.
	 */
	func setSpeechHighlight(_ highlighted: Bool) {
		// Apply colors according to highligh state.
		cellView.isSpeechHighlighted = highlighted
	}
}
