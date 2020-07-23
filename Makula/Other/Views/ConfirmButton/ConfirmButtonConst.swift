extension Const {
	/// Any constants for this view.
	struct ConfirmButton {
		/// The max number of lines the button title can have.
		static let maxTitleLines: Int = 2

		struct Margin {
			/// The margin for the button's content.
			static let content = Const.Margin.default.top(8).bottom(8)
		}
	}
}
