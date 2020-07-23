import Anchorage
import SwipeCellKit
import UIKit

class ContactMainCell: SwipeTableViewCell {
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
	private let mainCellView = ContactMainCellView()

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
	private var model: ContactMainCellModel?

	/**
	 Sets up the cell.

	 - parameter model: The cell's model.
	 */
	func setup(model: ContactMainCellModel) {
		// Apply model.
		self.model = model
		mainCellView.title = model.title
		mainCellView.editable = model.editable
		mainCellView.largeStyle = model.largeStyle
		mainCellView.defaultColor = model.defaultColor
		mainCellView.highlightColor = model.highlightColor

		// Register for callback actions
		mainCellView.onDragButtonPressed.setDelegate(to: self, with: { strongSelf, _ in
			model.delegate?.dragIndicatorButtonPressed(onMainCell: strongSelf)
		})
	}

	// MARK: - Cell highlight

	/// A cancellable dispatch block which resets the view colors after some time.
	private lazy var dehighlightWorker = DispatchedCall(for: self) { strongSelf in
		strongSelf.mainCellView.applyDefaultColor()
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		dehighlightWorker.cancel()

		// Apply colors according to state.
		if selected {
			mainCellView.applyHighlightColor()
		} else {
			// Delay de-highlighting
			dehighlightWorker.enqueue(for: Const.Time.defaultAnimationDuration)
		}
	}

	override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		dehighlightWorker.cancel()

		// Apply colors according to state.
		if highlighted {
			mainCellView.applyHighlightColor()
		} else {
			mainCellView.applyDefaultColor()
		}
	}
}
