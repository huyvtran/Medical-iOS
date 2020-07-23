import SwiftCharts
import Timepiece

class GraphChart {
	// MARK: - Setup

	/// The reference to the real chart this class encapsulates.
	private var chart: Chart?

	/// The current date from which to display the graph.
	private var currentDate: Date

	/// The gesture recognizer for the chart to not block other recognizers.
	private let chartGestureRecognizerDelegateObject = GraphChartGestureRecognizerDelegate()

	/// The label formatter for the X axis to display the month names.
	private let xAxisLabelFormatter: XAxisFormatter

	/// The value formatter to display the Visus values on the right axis.
	private let visusValueFormatter = VisusValueFormatter()

	/// The value formatter to display the NHD values on the left axis.
	private let nhdValueFormatter = NhdValueFormatter()

	/**
	 Initializes the chart.

	 - parameter currentDate: The current date from which to display the graph.
	 */
	init(currentDate: Date = Date()) {
		self.currentDate = currentDate
		xAxisLabelFormatter = XAxisFormatter(currentDate: currentDate)
	}

	/**
	 Creates a new chart which fits the given view size.
	 Uses the `nhdChartPoints` and `visusChartPoints` to display the graph.
	 After the chart is created the chart's `view` is available to embedd into the view hierarchy.

	 - parameter chartSize: The size of the chart.
	 - parameter largeStyle: Whether a large style should be used (landscape), or the default style (portrait).
	 */
	func createChart(chartSize: CGSize, largeStyle: Bool) {
		// Create axis models.
		let leftAxisModel = createLeftAxisModel(largeStyle: largeStyle)
		let rightAxisModel = createRightAxisModel(largeStyle: largeStyle)
		// The invisible horizontal axis on top of the chart to provide the vertical major grid lines.
		let xAxisGridModel = createTopXAxisModel(largeStyle: largeStyle)
		// The visible labels on the bottom horizontal axis displaying the months in between the major grid lines.
		let xAxisLabelModel = createBottomXAxisModel(largeStyle: largeStyle)

		// Configuration for the chart.
		let chartSettings = createChartSettings(largeStyle: largeStyle)

		// Get the chart piece spaces.
		let chartFrame = CGRect(origin: .zero, size: chartSize)
		let coordsSpace = ChartCoordsSpace(
			chartSettings: chartSettings,
			chartSize: chartFrame.size,
			yLowModels: [leftAxisModel],
			yHighModels: [rightAxisModel],
			xLowModels: [xAxisLabelModel],
			xHighModels: [xAxisGridModel]
		)
		let innerFrame = coordsSpace.chartInnerFrame

		// Create the layers stack.
		var layers: [ChartLayer] = []
		let xAxisGridLayer = coordsSpace.xHighAxesLayers[0]
		layers.append(xAxisGridLayer)
		let xAxisLabelLayer = coordsSpace.xLowAxesLayers[0]
		layers.append(xAxisLabelLayer)
		let leftAxisLayer = coordsSpace.yLowAxesLayers[0]
		layers.append(leftAxisLayer)
		let rightAxisLayer = coordsSpace.yHighAxesLayers[0]
		layers.append(rightAxisLayer)

		// Configure the graph's background grid.
		let guidelinesLayerSettings = ChartGuideLinesLayerSettings(
			linesColor: Const.Color.white,
			linesWidth: largeStyle ? Const.Size.separatorThicknessLarge : Const.Size.separatorThicknessNormal
		)
		let guidelinesLayer = ChartGuideLinesLayer(xAxisLayer: xAxisGridLayer, yAxisLayer: leftAxisLayer, settings: guidelinesLayerSettings)
		layers.append(guidelinesLayer)

		// NHD line.
		let nhdLineModel = ChartLineModel(
			chartPoints: nhdChartPoints,
			lineColor: Const.Color.yellow,
			lineWidth: largeStyle ? Const.Size.graphLineThicknessLarge : Const.Size.graphLineThicknessNormal,
			animDuration: 0,
			animDelay: 0
		)
		let nhdLineLayer = ChartPointsLineLayer(xAxis: xAxisGridLayer.axis, yAxis: leftAxisLayer.axis, lineModels: [nhdLineModel], delayInit: true)
		layers.append(nhdLineLayer)

		// Visus line.
		let visusLineModel = ChartLineModel(
			chartPoints: visusChartPoints,
			lineColor: Const.Color.green,
			lineWidth: largeStyle ? Const.Size.graphLineThicknessLarge : Const.Size.graphLineThicknessNormal,
			animDuration: 0,
			animDelay: 0
		)
		let visusLineLayer = ChartPointsLineLayer(xAxis: xAxisGridLayer.axis, yAxis: rightAxisLayer.axis, lineModels: [visusLineModel], delayInit: true)
		layers.append(visusLineLayer)

		// NHD dots.
		let dotScale = CGFloat(Const.Graph.Value.xAxisSteps / Const.Graph.Value.xAxisStepsPerPage) - 1.0
		let dotDiameter = largeStyle ? Const.Size.graphLineThicknessLarge : Const.Size.graphLineThicknessNormal
		let nhdDotViewGenerator = { (chartPointModel: ChartPointLayerModel, _: ChartPointsLayer, _: Chart) -> UIView? in
			let circleView = ChartPointEllipseView(
				center: chartPointModel.screenLoc,
				width: dotDiameter * CGFloat(Const.Graph.Value.dotFactor) / dotScale,
				height: dotDiameter * CGFloat(Const.Graph.Value.dotFactor)
			)
			circleView.fillColor = Const.Color.yellow
			return circleView
		}
		let nhdDotLayer = ChartPointsViewsLayer(
			xAxis: xAxisGridLayer.axis,
			yAxis: leftAxisLayer.axis,
			chartPoints: nhdChartPoints,
			viewGenerator: nhdDotViewGenerator
		)
		layers.append(nhdDotLayer)

		// Visus dots.
		let visusDotViewGenerator = { (chartPointModel: ChartPointLayerModel, _: ChartPointsLayer, _: Chart) -> UIView? in
			let circleView = ChartPointEllipseView(
				center: chartPointModel.screenLoc,
				width: dotDiameter * CGFloat(Const.Graph.Value.dotFactor) / dotScale,
				height: dotDiameter * CGFloat(Const.Graph.Value.dotFactor)
			)
			circleView.fillColor = Const.Color.green
			return circleView
		}
		let visusDotLayer = ChartPointsViewsLayer(
			xAxis: xAxisGridLayer.axis,
			yAxis: rightAxisLayer.axis,
			chartPoints: visusChartPoints,
			viewGenerator: visusDotViewGenerator
		)
		layers.append(visusDotLayer)

		// The vertical IVOM line, which uses the left axis.
		var ivomLineLayer: ChartPointsLineLayer<ChartPoint>?
		if let ivomDate = ivomDate {
			let ivomChartPoints: [ChartPoint] = [
				createChartPoint(date: ivomDate, value: Double(Const.Data.nhdMaxValue), largeStyle: largeStyle),
				createChartPoint(date: ivomDate, value: Double(Const.Data.nhdMinValue), largeStyle: largeStyle)
			]
			let ivomLineModel = ChartLineModel(
				chartPoints: ivomChartPoints,
				lineColor: Const.Color.magenta,
				lineWidth: largeStyle ? Const.Size.separatorThicknessLarge : Const.Size.separatorThicknessNormal,
				animDuration: 0,
				animDelay: 0
			)
			let layer = ChartPointsLineLayer(xAxis: xAxisGridLayer.axis, yAxis: leftAxisLayer.axis, lineModels: [ivomLineModel], delayInit: true)
			ivomLineLayer = layer
			layers.append(layer)
		}

		// Initialize the chart object.
		let chartView = ChartBaseView(frame: chartFrame)
		let chart = Chart(view: chartView, innerFrame: innerFrame, settings: chartSettings, layers: layers)
		self.chart = chart

		// Draw the lines. Needs the 'delayInit' property of the 'ChartPointsLineLayer' to be 'true'.
		nhdLineLayer.initScreenLines(chart)
		visusLineLayer.initScreenLines(chart)
		ivomLineLayer?.initScreenLines(chart)

		// Scroll initially to the end of the chart.
		chart.pan(x: -chart.contentFrame.width, y: 0, elastic: false)

		// Register as the delegate for the chart's pan gesture recognizer.
		// This property is as of v0.6.1 not public so the pod's source is modified as a workaround to make it available.
		chartView.panRecognizer?.delegate = chartGestureRecognizerDelegateObject
	}

	// MARK: - Publics

	/// The chart's view, available after calling `createChart`.
	var view: ChartView? {
		return chart?.view
	}

	/// The date of the last `IVOM` to display the vertical line.
	var ivomDate: Date?

	/// The NHD chart points used by the `createChart` method.
	var nhdChartPoints = [ChartPoint]()

	/// The Visus chart points used by the `createChart` method.
	var visusChartPoints = [ChartPoint]()

	/**
	 Creates a chart point to display.

	 - parameter date: The chart point's date represented on the X axis.
	 - parameter value: The chart point's value represented on the Y axis. The range depends on which of the two Y axes the point is for.
	 - parameter largeStyle: Whether to use a large style (landscape) or not (portrait).
	 */
	func createChartPoint(date: Date, value: Double, largeStyle: Bool) -> ChartPoint {
		let index = xAxisValueForDate(date)
		let labelSettings = ChartLabelSettings(
			font: largeStyle ? Const.Font.graphTextLarge : Const.Font.graphTextDefault,
			fontColor: Const.Color.white
		)
		let xAxisValue = ChartAxisValueDouble(index, formatter: xAxisLabelFormatter, labelSettings: labelSettings)
		return ChartPoint(x: xAxisValue, y: ChartAxisValueDouble(value))
	}

	/**
	 Transforms a date into a double representing the position on the X axis of the graph.

	 The X axis is defined from right to left with the current's date next month on the right as last value.
	 So when today is the 15th of June the end month on the right of the graph is 1st of July which has the value `0`.
	 June then is represend by `-1`, May as `-2`, etc.
	 The month's day is then transformed into a fraction of the month, e.g. the 15th is `0.5` which then gets added to the index.
	 June the 15th then would be transformed into `-0.5` that way.
	 June the 1st is then `-1` and July the 1st `0`.

	 - parameter date: The date on the X axis.
	 - returns: The date's representation value as a double.
	 */
	private func xAxisValueForDate(_ date: Date) -> Double {
		let calendar = self.calendar()
		let dateTruncated = date.truncated(from: .hour)!
		let endDate = (currentDate.startOfMonth() + 1.month)!
		let monthsDiff = endDate.months(to: dateTruncated, calendar: calendar)
		let daysInMonth = dateTruncated.daysInMonth(calendar: calendar)
		let dayNumber = dateTruncated.day
		let dayFraction = Double(dayNumber - 1) / Double(daysInMonth)
		let adjustment = dayNumber == 1 ? 0.0 : 1.0
		let value = Double(monthsDiff) - adjustment + dayFraction
		return value
	}

	/// The gregorian calendar to use for time calculations. Should cache the calendar, because it's time intensive to create.
	var calendar: () -> Calendar = {
		CommonDateFormatter.calendar
	}

	// MARK: - Helper for 'createChart'

	private func createLeftAxisModel(largeStyle: Bool) -> ChartAxisModel {
		let leftAxisLabelSettings = ChartLabelSettings(
			font: largeStyle ? Const.Font.graphNumbersLarge : Const.Font.graphNumbersDefault,
			fontColor: Const.Color.yellow
		)
		let leftAxisValues = stride(
			from: Const.Data.nhdMaxValue,
			through: Const.Data.nhdMinValue,
			by: -(Const.Data.nhdMaxValue - Const.Data.nhdMinValue) / Float(Const.Graph.Value.yAxisSteps)
		).map {
			ChartAxisValueDouble(Double($0), formatter: self.nhdValueFormatter, labelSettings: leftAxisLabelSettings)
		}
		let leftAxisModel = ChartAxisModel(axisValues: leftAxisValues, lineColor: Const.Color.white)
		return leftAxisModel
	}

	private func createRightAxisModel(largeStyle: Bool) -> ChartAxisModel {
		let rightAxisLabelSettings = ChartLabelSettings(
			font: largeStyle ? Const.Font.graphNumbersLarge : Const.Font.graphNumbersDefault,
			fontColor: Const.Color.green
		)
		let rightAxisValues = stride(
			from: Const.Data.visusMinValue,
			through: Const.Data.visusMaxValue,
			by: (Const.Data.visusMaxValue - Const.Data.visusMinValue) / Int(Const.Graph.Value.yAxisSteps)
		).map {
			ChartAxisValueDouble($0, formatter: self.visusValueFormatter, labelSettings: rightAxisLabelSettings)
		}
		let rightAxisModel = ChartAxisModel(axisValues: rightAxisValues, lineColor: Const.Color.white)
		return rightAxisModel
	}

	private func createTopXAxisModel(largeStyle: Bool) -> ChartAxisModel {
		let xAxisEmptyLabelSettings = ChartLabelSettings()
		let xAxisValueGenerator = ChartAxisGeneratorMultiplier(Const.Graph.Value.xAxisSteps / Const.Graph.Value.xAxisStepsPerPage)
		let xAxisEmptyLabelGenerator = ChartAxisLabelsGeneratorFunc { _ in return
			ChartAxisLabel(text: "", settings: xAxisEmptyLabelSettings)
		}
		let xAxisGridModel = ChartAxisModel(
			lineColor: Const.Color.white,
			firstModelValue: -Const.Graph.Value.xAxisSteps,
			lastModelValue: 0.0,
			axisTitleLabels: [],
			axisValuesGenerator: xAxisValueGenerator,
			labelsGenerator: xAxisEmptyLabelGenerator
		)
		return xAxisGridModel
	}

	private func createBottomXAxisModel(largeStyle: Bool) -> ChartAxisModel {
		let xAxisLabelSettings = ChartLabelSettings(
			font: largeStyle ? Const.Font.graphTextLarge : Const.Font.graphTextDefault,
			fontColor: Const.Color.white
		)
		let xAxisLabelsGenerator = ChartAxisLabelsGeneratorFunc { [weak self] value -> ChartAxisLabel in
			// Print label only in the middle of each interval.
			if abs(value.truncatingRemainder(dividingBy: 1.0)) == 0.5, let text = self?.xAxisLabelFormatter.string(for: value) {
				return ChartAxisLabel(text: text, settings: xAxisLabelSettings)
			} else {
				return ChartAxisLabel(text: "", settings: xAxisLabelSettings)
			}
		}
		let xAxisLabelValueGenerator = ChartAxisGeneratorMultiplier(1)
		let xAxisLabelModel = ChartAxisModel(
			lineColor: Const.Color.white,
			firstModelValue: -Const.Graph.Value.xAxisSteps,
			lastModelValue: 0.0,
			axisTitleLabels: [],
			axisValuesGenerator: xAxisLabelValueGenerator,
			labelsGenerator: xAxisLabelsGenerator
		)
		return xAxisLabelModel
	}

	private func createChartSettings(largeStyle: Bool) -> ChartSettings {
		var chartSettings = ChartSettings()
		chartSettings.leading = -5
		chartSettings.top = -14
		chartSettings.trailing = -5
		chartSettings.bottom = 18
		chartSettings.labelsToAxisSpacingX = 5
		chartSettings.labelsToAxisSpacingY = 5
		chartSettings.axisTitleLabelsToLabelsSpacing = 4
		chartSettings.axisStrokeWidth = largeStyle ? Const.Size.separatorThicknessLarge : Const.Size.separatorThicknessNormal
		chartSettings.spacingBetweenAxesX = 8
		chartSettings.spacingBetweenAxesY = 8
		chartSettings.labelsSpacing = 0
		// Set a fixed (horizontal) scrollable area 4x than the original width, with zooming disabled.
		chartSettings.zoomPan.panEnabled = true
		chartSettings.zoomPan.zoomEnabled = false
		chartSettings.zoomPan.maxZoomX = CGFloat(Const.Graph.Value.xAxisSteps / Const.Graph.Value.xAxisStepsPerPage)
		chartSettings.zoomPan.minZoomX = CGFloat(Const.Graph.Value.xAxisSteps / Const.Graph.Value.xAxisStepsPerPage)
		chartSettings.zoomPan.maxZoomY = 1
		chartSettings.zoomPan.minZoomY = 1
		return chartSettings
	}
}

// MARK: - GraphChartGestureRecognizerDelegate

/// A class which's purpose is solely to tell a gesture recognizer to allow simultaneously interactions.
class GraphChartGestureRecognizerDelegate: NSObject, UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		// Necessary to prevent the graph from blocking touches for the table view.
		return true
	}
}
