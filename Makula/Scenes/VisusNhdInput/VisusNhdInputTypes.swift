// Any global types for this scene.

extension VisusNhdType {
	/**
	 Returns the title for the scene.

	 - returns: The scene's title string.
	 */
	func visusNhdInputTitleString() -> String {
		switch self {
		case .visus:
			return R.string.visusNhdInput.visusTitle()
		case .nhd:
			return R.string.visusNhdInput.nhdTitle()
		}
	}
}
