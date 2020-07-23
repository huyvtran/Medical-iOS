import BonMot
import UIKit

extension Const {
	struct Font {
		/// The main title font with default size, e.g. the header in portrait mode.
		static let titleDefault = R.font.theSansB7Bold(size: 32)!

		/// The main title font with large size, e.g. the header in landscape mode.
		static let titleLarge = R.font.theSansB7Bold(size: 57)!

		/// The headline #1 font with default size, e.g. for the menu cells in portrait mode.
		static let headline1Default = R.font.theSansB7Bold(size: 32)!

		/// The headline #1 font with large size, e.g. for the menu cells in landscape mode.
		static let headline1Large = R.font.theSansB7Bold(size: 57)!

		/// The content text #1 font with default size, e.g. for the disclaimer in portrait mode.
		static let content1Default = R.font.theSansB7Bold(size: 26)!

		/// The content text #1 font with large size, e.g. for the disclaimer in landscape mode.
		static let content1Large = R.font.theSansB7Bold(size: 46)!

		/// The content text #2 font with default size, e.g. for the week names in the calendar in portrait mode.
		static let content2Default = R.font.theSansB7Bold(size: 24)!

		/// The content text #2 font with large size, e.g. for the week names in the calendar in landscape mode.
		static let content2Large = R.font.theSansB7Bold(size: 43)!

		/// The font for numbers with a default size, e.g. for the calendar and graph in portrait mode.
		static let numbersDefault = R.font.theSansBoldExpert(size: 30)!

		/// The font for numbers with a large size, e.g. for the calendar and graph in landscape mode.
		static let numbersLarge = R.font.theSansBoldExpert(size: 54)!

		/// The font for the readingtest with a big size.
		static let readingtestBig = R.font.theSansB7Bold(size: 42)!

		/// The font for the readingtest with a large size.
		static let readingtestLarge = R.font.theSansB7Bold(size: 32)!

		/// The font for the readingtest with a medium size.
		static let readingtestMedium = R.font.theSansB7Bold(size: 24)!

		/// The font for the readingtest with a small size.
		static let readingtestSmall = R.font.theSansB7Bold(size: 18)!

		/// The font for the readingtest with a little size.
		static let readingtestLittle = R.font.theSansB7Bold(size: 15)!

		/// The font for the readingtest with a tiny size.
		static let readingtestTiny = R.font.theSansB7Bold(size: 12)!

		/// The font for numbers in the graph with a default size.
		static let graphNumbersDefault = R.font.theSansBoldExpert(size: 24)!

		/// The font for numbers in the graph with a large size.
		static let graphNumbersLarge = R.font.theSansBoldExpert(size: 30)!

		/// The text in the graph with a default size.
		static let graphTextDefault = R.font.theSansB7Bold(size: 24)!

		/// The text in the graph with a large size.
		static let graphTextLarge = R.font.theSansB7Bold(size: 30)!
	}

	struct StringStyle {
		/// The base style to apply to all text. Use `BonMot` for custom styling, e.g. `myString.styled(with: Const.StringStyle.base.byAdding(...))`.
		static let base = BonMot.StringStyle(.lineSpacing(0))
	}
}
