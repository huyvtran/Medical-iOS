import UIKit

extension Const {
	/// Any global size values, e.g. widths & heights.
	struct Size {
		/// The factor to apply on views when in landscape where they should be shown scaled up.
		static let landscapeScaleFactor: CGFloat = 1.78

		/// A default size for adding between two view elements so they won't be too close to each other.
		/// Use this value for creating constraints between views when there should be a gap between them.
		static let defaultGap: CGFloat = 6

		/// The estimation height for default cells.
		static let cellEstimatedDefaultHeight: CGFloat = 73.0

		/// The min height for a default title label in a cell.
		static let cellDefaultLabelMinHeight: CGFloat = 52.0

		/// The default thickness of the separator lines in normal mode.
		static let separatorThicknessNormal: CGFloat = 2.5

		/// The thickness of the separator lines in large mode.
		static let separatorThicknessLarge: CGFloat = 4

		/// The default thickness of the graph lines in normal mode.
		static let graphLineThicknessNormal: CGFloat = 5

		/// The thickness of the graph lines in large mode.
		static let graphLineThicknessLarge: CGFloat = 8
	}

	/// Any time interval constants.
	struct Time {
		/// The duration for default animations.
		static let defaultAnimationDuration: TimeInterval = 0.25
	}

	/// Data model value borders.
	struct Data {
		/// The lower boundary of the visus value for an eye.
		static let visusMinValue: Int = 0
		/// The upper boundary of the visus value for an eye.
		static let visusMaxValue: Int = 12
		/// The lower boundary of the NHD value.
		static let nhdMinValue: Float = 220
		/// The upper boundary of the NHD value.
		static let nhdMaxValue: Float = 460
	}
}
