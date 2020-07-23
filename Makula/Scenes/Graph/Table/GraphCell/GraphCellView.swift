import Anchorage
import Timepiece
import UIKit

@IBDesignable
class GraphCellView: UIView {
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
		addSubview(leftTitleLabel)
		addSubview(rightTitleLabel)
		addSubview(chartViewContainer)

		// The title over the left axis.
		leftTitleLabel.leadingAnchor == layoutMarginsGuide.leadingAnchor
		leftTitleLabel.topAnchor == layoutMarginsGuide.topAnchor
		leftTitleLabel.heightAnchor >= Const.Size.cellDefaultLabelMinHeight

		// The title over the right axis.
		rightTitleLabel.topAnchor == layoutMarginsGuide.topAnchor
		rightTitleLabel.trailingAnchor == layoutMarginsGuide.trailingAnchor
		rightTitleLabel.heightAnchor >= Const.Size.cellDefaultLabelMinHeight

		// Connect both labels, let them take the space necessary, but let the left break
		rightTitleLabel.leadingAnchor >= leftTitleLabel.trailingAnchor
		leftTitleLabel.horizontalCompressionResistance = .high + 1

		// The graph's container takes up the rest of the space under the labels.
		// The graph itself will be added to the container in the layout phase.
		chartViewContainer.leadingAnchor == layoutMarginsGuide.leadingAnchor
		chartViewContainer.trailingAnchor == layoutMarginsGuide.trailingAnchor
		chartViewContainer.bottomAnchor == layoutMarginsGuide.bottomAnchor
		chartViewContainer.topAnchor == leftTitleLabel.bottomAnchor
		chartViewContainer.topAnchor == rightTitleLabel.bottomAnchor

		// View's height.
		heightAnchor == 440 ~ .required - 1

		// Apply margins.
		if #available(iOS 11.0, *) {
			directionalLayoutMargins = Const.Margin.cell.directional
		} else {
			layoutMargins = Const.Margin.cell
		}

		// Set default styles.
		backgroundColor = Const.Color.darkMain
		largeStyle = { largeStyle }()
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		// Remove an old instance of the chart view.
		if let chartView = chart?.view {
			chartView.removeFromSuperview()
		}

		// Create a new chart view.
		chart?.createChart(chartSize: chartViewContainer.bounds.size, largeStyle: largeStyle)
		if let chartView = chart?.view {
			// Add the chart's view to the view hierarchy.
			chartViewContainer.addSubview(chartView)
			chartView.edgeAnchors == chartViewContainer.edgeAnchors
		}
	}

	/// A reference to the chart currently beeing displayed.
	private var chart: GraphChart?

	// MARK: - Subviews

	/// The title over the left axis.
	private let leftTitleLabel: UILabel = {
		let label = UILabel()
		label.attributedText = R.string.graph.graphTitleLeft().styled(with: Const.StringStyle.base)
		label.textColor = Const.Color.yellow
		label.textAlignment = .left
		return label
	}()

	/// The title over the right axis.
	private let rightTitleLabel: UILabel = {
		let label = UILabel()
		label.attributedText = R.string.graph.graphTitleRight().styled(with: Const.StringStyle.base)
		label.textColor = Const.Color.green
		label.textAlignment = .right
		return label
	}()

	/// The view which embedds the chart view and therefore provides the chart's size.
	private let chartViewContainer: UIView = {
		let view = UIView(frame: .max)
		view.isOpaque = false
		view.backgroundColor = .clear
		return view
	}()

	// MARK: - Properties

	/**
	 Sets up the chart for display. Needs to be called once before the graph can be shown.

	 - parameter nhdModels: The NHD models for the orange line.
	 - parameter visusModels: The Visus models for the green line.
	 - parameter ivomDate: The date of the last IVOM entry to show as red line.
	 - parameter eyeType: The type of eye for which to show the data.
	 - parameter largeStyle: Whether the view uses a large font for labels or not.
	 */
	func setupChart(nhdModels: [NhdModel], visusModels: [VisusModel], ivomDate: Date?, eyeType: EyeType, largeStyle: Bool) {
		// Apply style.
		self.largeStyle = largeStyle

		// Create chart if necessary.
		if chart == nil {
			chart = GraphChart()
		}
		guard let chart = chart else { fatalError() }

		// Prepare chart's data.
		chart.nhdChartPoints = nhdModels.map {
			chart.createChartPoint(date: $0.date, value: eyeType == .left ? Double($0.valueLeft) : Double($0.valueRight), largeStyle: largeStyle)
		}
		chart.visusChartPoints = visusModels.map {
			let value = eyeType == .left ? Double($0.valueLeft) : Double($0.valueRight)
			return chart.createChartPoint(date: $0.date, value: value, largeStyle: largeStyle)
		}
		chart.ivomDate = ivomDate

		// Force a re-layout to update the chart view.
		setNeedsLayout()
	}

	/// Whether the view uses a large font for labels or not. Defaults to `false`.
	var largeStyle = false {
		didSet {
			leftTitleLabel.font = largeStyle ? Const.Font.content1Large : Const.Font.content1Default
			rightTitleLabel.font = largeStyle ? Const.Font.content1Large : Const.Font.content1Default
			setNeedsLayout()
		}
	}

	// MARK: - Interface Builder

	@IBInspectable private lazy var ibLargeStyle: Bool = false
	@IBInspectable private lazy var ibExampleIndex: Int = 0

	override func prepareForInterfaceBuilder() {
		// For crashing reports look at '~/Library/Logs/DiagnosticReports/'.
		super.prepareForInterfaceBuilder()

		translatesAutoresizingMaskIntoConstraints = true
		backgroundColor = Const.Color.darkMain

		largeStyle = ibLargeStyle

		if ibExampleIndex == 1 {
			let chart = GraphChart(currentDate: Date(year: 2018, month: 6, day: 15))
			self.chart = chart
			chart.ivomDate = Date(year: 2018, month: 6, day: 15)
			chart.nhdChartPoints = [
				chart.createChartPoint(date: Date(year: 2018, month: 1, day: 2), value: 440, largeStyle: largeStyle),
				chart.createChartPoint(date: Date(year: 2018, month: 3, day: 31), value: 300, largeStyle: largeStyle),
				chart.createChartPoint(date: Date(year: 2018, month: 4, day: 8), value: 360, largeStyle: largeStyle),
				chart.createChartPoint(date: Date(year: 2018, month: 6, day: 1), value: 240, largeStyle: largeStyle),
				chart.createChartPoint(date: Date(year: 2018, month: 6, day: 15), value: 260, largeStyle: largeStyle)
			]
			chart.visusChartPoints = [
				chart.createChartPoint(date: Date(year: 2018, month: 1, day: 2), value: 12, largeStyle: largeStyle),
				chart.createChartPoint(date: Date(year: 2018, month: 3, day: 31), value: 5, largeStyle: largeStyle),
				chart.createChartPoint(date: Date(year: 2018, month: 4, day: 25), value: 11, largeStyle: largeStyle),
				chart.createChartPoint(date: Date(year: 2018, month: 6, day: 1), value: 3, largeStyle: largeStyle),
				chart.createChartPoint(date: Date(year: 2018, month: 6, day: 15), value: 0, largeStyle: largeStyle)
			]
		}
	}
}
