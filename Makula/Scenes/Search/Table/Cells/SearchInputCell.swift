import Anchorage
import UIKit

class SearchInputCell: BaseCell {
	// MARK: - Init

	public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .default, reuseIdentifier: reuseIdentifier)
		configureView()
	}

	// MARK: - View configuration

	/// The cell's view.
	private let cellView = SearchInputCellView()

	/**
	 Sets up the view hierarchy and layout.
	 */
	private func configureView() {
		// Embed the view into this cell.
		contentView.addSubview(cellView)
		cellView.edgeAnchors == contentView.edgeAnchors

		// No highlighting.
		selectionStyle = .none
	}

	// MARK: - Setup

	/// The cell's model.
	private var model: SearchInputCellModel?

	/**
	 Sets up the cell.

	 - parameter model: The cell's model.
	 */
	func setup(model: SearchInputCellModel) {
		// Apply model.
		self.model = model
		cellView.largeStyle = model.largeStyle
		cellView.textFieldText = model.searchText
		cellView.textFieldDelegate = model.delegate
	}

	/**
	 Makes the cell view's text field the first responder.
	 */
	func makeTextFieldFirstResponder() {
		cellView.makeTextFieldFirstResponder()
	}
}
