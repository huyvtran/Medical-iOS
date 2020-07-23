import UIKit

class NoteTextViewController: NSObject {
	// MARK: - Properties

	/// The main view this controller manages.
	private let mainView: NoteView

	/// A reference to the logic.
	private weak var logic: NoteLogicInterface?

	// MARK: - Init

	/**
	 Sets up the controller with needed references.

	 - parameter mainView: The reference to the main view this controller should manage.
	 - parameter logic: The logic which becomes the delegate. Will not be retained.
	 */
	init(mainView: NoteView, logic: NoteLogicInterface) {
		self.mainView = mainView
		self.logic = logic
		super.init()
	}
}

// MARK: - UITextViewDelegate

extension NoteTextViewController: UITextViewDelegate {
	func textViewDidBeginEditing(_ textView: UITextView) {
		if mainView.isContentEmpty {
			textView.text = String.empty
			textView.textColor = Const.Color.darkMain
		}
	}

	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if text == "\n" {
			textView.resignFirstResponder()
			return false
		}
		return true
	}

	func textViewDidEndEditing(_ textView: UITextView) {
		// Update the text view.
		let content = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
		if content.isEmpty {
			mainView.isContentEmpty = true
		} else {
			mainView.isContentEmpty = false
			textView.text = content
		}

		// Updates the note model.
		logic?.updateNoteModel(content: content)
	}
}
