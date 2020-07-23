import Anchorage
import UIKit

class DiagnosisMainCell: BaseCell {
	// MARK: - Init

	public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configureView()
	}

	// MARK: - View configuration

	/// The cell's main view.
	private let mainCellView = DiagnosisMainCellView()

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
	private var model: DiagnosisMainCellModel?

	/**
	 Sets up the cell.

	 - parameter model: The cell's model.
	 */
	func setup(model: DiagnosisMainCellModel) {
		// Apply model.
		self.model = model
		mainCellView.title = model.title
		mainCellView.subtitle = model.subtitle
		mainCellView.largeStyle = model.largeStyle
		mainCellView.onInfoButtonPressed.setDelegate(to: self, with: { strongSelf, _ in
			model.delegate?.infoButtonPressed(onMainCell: strongSelf, index: model.rowIndex)
		})
		accessibilityIdentifier = model.accessibilityIdentifier
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

	// MARK: - Action

	func infoButtonPressed() {
		Log.debug("Info button logic not implemented")
	}
}
