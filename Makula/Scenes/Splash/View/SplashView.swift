import Anchorage
import UIKit

/**
 The scene controller's root view.

 This will be created in the controller's `loadView` method and creates the view with code instead of using Xibs and Storyboards.
 The root view is responsible for creating the view hierarchy and holds all subview references so that the display can access them.
 The view also forwards any user actions from controls to the logic.
 And the view might also provide additional code for displaying certain view states,
 but the view does NOT perform any logic nor formatting.
 */
@IBDesignable
class SplashView: UIView {
	// MARK: - Init

	/// A weak reference to the logic for informing about any user actions in this view.
	private weak var logic: SplashLogicInterface?

	/**
	 Initializes this view.

	 - parameter logic: The logic to inform about any user actions. Will not be retained.
	 */
	init(logic: SplashLogicInterface) {
		self.logic = logic
		super.init(frame: .max)
		configureView()
	}

	@available(*, unavailable)
	override init(frame: CGRect) {
		// Needed for InterfaceBuilder
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
		accessibilityIdentifier = Const.SplashTests.ViewName.mainView

		// Create view hierarchy.
		addSubview(logoView)

		// Place the logo at the top.
		logoView.centerXAnchor == centerXAnchor
		logoView.centerYAnchor == centerYAnchor - 24

		// Set default styles.
		backgroundColor = Const.Color.pompadour
		logoVisible = { logoVisible }()
	}

	// MARK: - Subviews

	/// The image view at the top representing the logo.
	private let logoView: UIImageView = {
		let logoView = UIImageView(image: R.image.amd_netz_logo())
		logoView.contentMode = .scaleAspectFit
		return logoView
	}()

	// MARK: - Properties

	/// The visibility state of the logo. Set to `true` (default) to show the logo or to `false` to hide it.
	/// This state is animatable because the logo's alpha is only changed.
	var logoVisible = true {
		didSet {
			logoView.alpha = logoVisible ? 1.0 : 0.0
		}
	}

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibLogoVisible: Bool = logoVisible

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()

		logoVisible = ibLogoVisible
	}
}
