import Foundation

/// The model for the `GraphCell`.
struct GraphCellModel {
	/// When true the cell uses a large style for text and buttons (e.g. for landscape mode),
	/// while false uses the default style (e.g. for portrait).
	let largeStyle: Bool
	/// The date of the last treatment appointment if available.
	let ivomDate: Date?
	/// The NHD models to show in the graph.
	let nhdModels: [NhdModel]
	/// The Visus models to show in the graph.
	let visusModels: [VisusModel]
	/// The type of eye this scene represents.
	let eyeType: EyeType
}
