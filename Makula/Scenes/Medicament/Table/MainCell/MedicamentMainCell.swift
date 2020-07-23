import Anchorage
import SwipeCellKit
import UIKit

class MedicamentMainCell: SwipeTableViewCell {
	// MARK: - Init

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .default, reuseIdentifier: reuseIdentifier)
		configureView()
	}

	@available(*, unavailable, message: "Instantiating via Xib & Storyboard is prohibited.")
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View configuration

	/// The cell's main view.
	private let mainCellView = MedicamentMainCellView()

	/**
	 Sets up the view hierarchy and layout.
	 */
	private func configureView() {
		// Embed the main view into this cell.
		contentView.addSubview(mainCellView)
		mainCellView.edgeAnchors == contentView.edgeAnchors

		// Clear cell background highlight.
		selectedBackgroundView = UIView.viewWithColor(UIColor.clear)
	}

	// MARK: - Setup

	/// The cell's model.
	private var model: MedicamentMainCellModel?

	/**
	 Sets up the cell.

	 - parameter model: The cell's model.
	 */
	func setup(model: MedicamentMainCellModel) {
		// Apply model.
		self.model = model
		mainCellView.title = model.title
		mainCellView.largeStyle = model.largeStyle
		mainCellView.editable = model.editable

		// Register for callback actions
		mainCellView.onDragButtonPressed.setDelegate(to: self, with: { strongSelf, _ in
			model.delegate?.dragIndicatorButtonPressed(onMainCell: strongSelf)
		})
	}

	// MARK: - Cell highlight

	/**
	 Highlights/De-highlights the speech text in the cell.

	 - parameter highlighted: The highlight state. `true` to highlight, `false` to de-highlight.
	 */
	func setSpeechHighlight(_ highlighted: Bool) {
		// Apply colors according to highligh state.
		mainCellView.isSpeechHighlighted = highlighted
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)

		// Apply colors according to state.
		if selected {
			mainCellView.applyHighlightColor()
		} else {
			mainCellView.applyDefaultColor()
		}
	}

	override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		super.setHighlighted(highlighted, animated: animated)

		// Apply colors according to the selected state.
		if isSelected {
			mainCellView.applyHighlightColor()
		} else {
			mainCellView.applyDefaultColor()
		}
	}
}
