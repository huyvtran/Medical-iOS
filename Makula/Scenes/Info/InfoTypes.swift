import SwiftRichString

// Any global types for this scene.
struct InfoTextStyle {
	struct Default {
		// The string style of the content.
		static let body = Style {
			$0.font = Const.Font.content1Default
			$0.color = Const.Color.darkMain
		}

		// The string style of the content title.
		static let header1 = Style {
			$0.font = Const.Font.headline1Default
			$0.color = Const.Color.darkMain
		}

		// The string style of the content subtitle.
		static let header2 = Style {
			$0.font = Const.Font.headline1Default
			$0.color = Const.Color.white
		}

		// The string style for a hyperlink.
		static let hyperlink = Style {
			$0.font = Const.Font.content1Default
			$0.color = Const.Color.white
		}

		static let group = StyleGroup(base: body, ["h1": header1, "h2": header2, "a": hyperlink])
	}

	struct Large {
		// The string style of the content in landscape mode.
		static let body = Style {
			$0.font = Const.Font.content1Large
			$0.color = Const.Color.darkMain
		}

		// The string style of the content title in landscape mode.
		static let header1 = Style {
			$0.font = Const.Font.headline1Large
			$0.color = Const.Color.darkMain
		}

		// The string style of the content subtitle in landscape mode.
		static let header2 = Style {
			$0.font = Const.Font.headline1Large
			$0.color = Const.Color.white
		}

		// The string style for a hyperlink.
		static let hyperlink = Style {
			$0.font = Const.Font.content1Large
			$0.color = Const.Color.white
		}

		static let group = StyleGroup(base: body, ["h1": header1, "h2": header2, "a": hyperlink])
	}
}
