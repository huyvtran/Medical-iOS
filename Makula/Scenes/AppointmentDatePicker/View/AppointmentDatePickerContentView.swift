import Anchorage
import UIKit

/**
 The content view of the appointment date picker scene's scroll view.
 Shows the date/time picker and the navigation bar.
 */
@IBDesignable
class AppointmentDatePickerContentView: UIView {
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
		accessibilityIdentifier = Const.AppointmentDatePickerTests.ViewName.scrollContentView
		translatesAutoresizingMaskIntoConstraints = false

		// Create view hierarchy.
		addSubview(navigationView)
		addSubview(datePicker)

		// Position the navigation view at the top.
		navigationView.leadingAnchor == leadingAnchor
		navigationView.trailingAnchor == trailingAnchor
		navigationView.topAnchor == topAnchor

		// Place the picker at the center.
		datePicker.leadingAnchor == layoutMarginsGuide.leadingAnchor
		datePicker.trailingAnchor == layoutMarginsGuide.trailingAnchor
		datePicker.topAnchor == navigationView.bottomAnchor + Const.AppointmentDatePicker.Value.pickerGap
		datePicker.bottomAnchor == layoutMarginsGuide.bottomAnchor ~ .low - 1

		// Apply margins.
		if #available(iOS 11.0, *) {
			directionalLayoutMargins = Const.Margin.default.directional
		} else {
			layoutMargins = Const.Margin.default
		}

		// Set default styles.
		backgroundColor = Const.Color.darkMain
	}

	// MARK: - Subviews

	/// The navigation view at the top of the view.
	private let navigationView: NavigationView = {
		let view = NavigationView()
		view.title = R.string.appointmentDatePicker.title()
		view.leftButtonType = .back
		view.leftButtonVisible = true
		view.rightButtonVisible = false
		return view
	}()

	/// The date picker.
	private let datePicker: UIDatePicker = {
		let picker = UIDatePicker()
		picker.accessibilityIdentifier = Const.AppointmentDatePickerTests.ViewName.datePicker
		picker.backgroundColor = UIColor.clear
		picker.isOpaque = false
		picker.setValue(Const.Color.white, forKey: "textColor")
		picker.datePickerMode = .dateAndTime
		picker.minuteInterval = Const.AppointmentDatePicker.Value.pickerMinuteInterval
		picker.setDate(Date(), animated: false)

		// Use the device's locale for the picker instead of the app's development language.
		let deviceLocale: Locale
		if let preferredUserLanguage = Locale.preferredLanguages.first {
			deviceLocale = Locale(identifier: preferredUserLanguage)
		} else {
			deviceLocale = Locale.autoupdatingCurrent
		}
		picker.locale = deviceLocale

		return picker
	}()

	// MARK: - Properties

	/// Whether the view uses a large style for sub-views. Defaults to `false`.
	var largeStyle = false {
		didSet {
			navigationView.largeStyle = largeStyle
		}
	}

	/// The currently selected appointment date shown in the picker.
	var pickerDate: Date {
		get { return datePicker.date }
		set { datePicker.setDate(newValue, animated: false) }
	}

	/// The delegate caller who informs about a left button press in the navigation view.
	var onLeftButtonPressedInNavigation: ControlCallback<NavigationView> { return navigationView.onLeftButtonPressed }

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibLarge: Bool = largeStyle

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()

		backgroundColor = Const.Color.darkMain
		translatesAutoresizingMaskIntoConstraints = true
		largeStyle = ibLarge
	}
}
