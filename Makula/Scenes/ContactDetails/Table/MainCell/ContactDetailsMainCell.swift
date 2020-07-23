import Anchorage
import SwipeCellKit
import UIKit

class ContactDetailsMainCell: SwipeTableViewCell {
	// MARK: - Init

	public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .default, reuseIdentifier: reuseIdentifier)
		configureView()
	}

	@available(*, unavailable, message: "Instantiating via Xib & Storyboard is prohibited.")
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View configuration

	/// The cell's main view.
	private let mainCellView = ContactDetailsMainCellView()

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
	private var model: ContactDetailsMainCellModel?

	/**
	 Sets up the cell.

	 - parameter model: The cell's model.
	 */
	func setup(model: ContactDetailsMainCellModel) {
		// Apply model.
		self.model = model
		mainCellView.defaultColor = model.defaultColor
		mainCellView.highlightColor = model.highlightColor
		mainCellView.editable = model.editable
		mainCellView.actable = model.actable
		mainCellView.largeStyle = model.largeStyle
		mainCellView.textFieldDelegate = model.delegate
		accessibilityIdentifier = model.accessibilityIdentifier

		if let text = model.title {
			mainCellView.showTitle(text)
		} else {
			mainCellView.showTextField(placeholder: model.type.defaultString(), tag: model.type.rawValue)
		}

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

	/// A cancellable dispatch block which resets the view colors after some time.
	private lazy var dehighlightWorker = DispatchedCall(for: self) { strongSelf in
		strongSelf.mainCellView.applyDefaultColor()
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		guard let model = model else { return }
		if !model.actable { return }

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
		guard let model = model else { return }
		if !model.actable { return }

		dehighlightWorker.cancel()

		// Apply colors according to state.
		if highlighted {
			mainCellView.applyHighlightColor()
		} else {
			mainCellView.applyDefaultColor()
		}
	}
}
