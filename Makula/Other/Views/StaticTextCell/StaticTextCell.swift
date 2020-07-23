import Anchorage
import UIKit

class StaticTextCell: BaseCell {
	// MARK: - Init

	public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configureView()
	}

	// MARK: - View configuration

	/// The cell's main view.
	private let menuMainCellView = StaticTextCellView()

	/**
	 Sets up the view hierarchy and layout.
	 */
	private func configureView() {
		// Embed the main view into this cell.
		contentView.addSubview(menuMainCellView)
		menuMainCellView.edgeAnchors == contentView.edgeAnchors

		// Clear cell background highlight.
		selectedBackgroundView = UIView.viewWithColor(UIColor.clear)
	}

	// MARK: - Setup

	/// The cell's model.
	private var model: StaticTextCellModel?

	/**
	 Sets up the cell.

	 - parameter model: The cell's model.
	 */
	func setup(model: StaticTextCellModel) {
		// Apply model.
		self.model = model
		menuMainCellView.title = model.title
		menuMainCellView.defaultColor = model.defaultColor
		menuMainCellView.highlightColor = model.highlightColor ?? model.defaultColor
		menuMainCellView.backColor = model.backgroundColor
		menuMainCellView.separatorVisible = model.separatorVisible
		menuMainCellView.separatorDefaultColor = model.separatorDefaultColor ?? menuMainCellView.defaultColor
		menuMainCellView.separatorHighlightColor = model.separatorHighlightColor ?? menuMainCellView.highlightColor
		menuMainCellView.largeStyle = model.largeFont
		menuMainCellView.centeredText = model.centeredText
		accessibilityIdentifier = model.accessibilityIdentifier
		isUserInteractionEnabled = !model.disabled
	}

	// MARK: - Cell highlight

	/// A cancellable dispatch block which resets the view colors after some time.
	private lazy var dehighlightWorker = DispatchedCall(for: self) { strongSelf in
		strongSelf.menuMainCellView.applyDefaultColor()
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		dehighlightWorker.cancel()

		// Apply colors according to state.
		if selected {
			menuMainCellView.applyHighlightColor()
		} else {
			// Delay de-highlighting
			dehighlightWorker.enqueue(for: Const.Time.defaultAnimationDuration)
		}
	}

	override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		dehighlightWorker.cancel()

		// Apply colors according to state.
		if highlighted {
			menuMainCellView.applyHighlightColor()
		} else {
			menuMainCellView.applyDefaultColor()
		}
	}
}
