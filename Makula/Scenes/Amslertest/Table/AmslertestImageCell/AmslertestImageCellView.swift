import Anchorage
import UIKit

@IBDesignable
class AmslertestImageCellView: UIView {
	// MARK: - Init

	init() {
		super.init(frame: .max)
		configureView()
	}

	@available(*, unavailable)
	override init(frame: CGRect) {
		// Needed to render in InterfaceBuilder.
		super.init(frame: frame)
		configureView()
	}

	@available(*, unavailable, message: "Instantiating via Xib & Storyboard is prohibited.")
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	/**
	 Builds up the view hierarchy and applies the layout.
	 */
	private func configureView() {
		translatesAutoresizingMaskIntoConstraints = false

		// Create view hierarchy.
		addSubview(imageView)

		// The cell image is centered in the view.
		imageView.edgeAnchors == edgeAnchors
		imageView.heightAnchor == Const.Amslertest.Size.gridImageHeight ~ .required - 1

		// Apply margins.
		if #available(iOS 11.0, *) {
			directionalLayoutMargins = Const.Margin.cell.directional
		} else {
			layoutMargins = Const.Margin.cell
		}

		// Set default styles.
		backgroundColor = Const.Color.white
	}

	// MARK: - Subviews

	/// The image view to fill up the view.
	private let imageView: UIImageView = {
		let imageView = UIImageView(frame: .max)
		imageView.contentMode = .center
		imageView.clipsToBounds = true
		imageView.image = R.image.amslergrid()
		return imageView
	}()

	// MARK: - Properties

	// MARK: - Interface Builder

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()

		translatesAutoresizingMaskIntoConstraints = true
	}
}
