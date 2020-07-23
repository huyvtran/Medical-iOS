import UIKit

// Add any global types.

/**
 A bucket for holding and providing global data which will be needed throughout the app.

 This holds the references to other worker, manager or data  which should be passed through routing the scenes.
 With this dependency injection is used rather than a global singleton.
 */
struct GlobalData {
	/// The internal settings with persisted data in the standard UserDefaults.
	var internalSettings: InternalSettingsInterface
	/// The data model manager for the app which manages all the app's internal data.
	var dataModelManager: DataModelManagerInterface
	/// The notification worker to schedule local notifications.
	var notificationWorker: NotificationWorkerInterface
}

/// All possible scenes in the app.
enum SceneId {
	/// The root of the menu, scene 1.1 "Makula-App".
	case home
	/// Scene 2.1 "Arztbesuch".
	case doctorVisit
	/// Scene 2.2 "Neue Termine".
	case newAppointment
	/// Scene 2.4 "Kontakte".
	case contact
	/// Scene 2.5 "Selbsttests".
	case selfTest
	/// Scene 3.2. "Diagnose".
	case diagnosis
	/// Scene, scene 3.3. "Medikamente".
	case medicament
	/// The visus / NHD Input scene 3.4 / 3.5 "Visus-Eingabe" / "NHD-Eingabe".
	case visusNhdInput
	/// Scene 2.3 "Kalender".
	case calendar
	/// Scene 3.11 "Amslertest".
	case amslertest
	/// Scene 3.12 "Lesetest".
	case readingTest
	/// The graph scene 3.6 / 3.7 "NH-Dicke/Visus".
	case graph
	/// Scene 2.6 (Flowchart2) "Wissen".
	case knowledge
	/// Scene 2.7 (Flowchart2) "Einstellungen".
	case settings
	/// Scene 3.1 (Flowchart2) "Erkrankung".
	case illness
	/// Scene 3.2 (Flowchart2) "Untersuchung".
	case examination
	/// Scene 3.3 (Flowchart2) "Therapie".
	case therapy
	/// Scene 3.4 (Flowchart2) "Maßnahmen".
	case activities
	/// Scene 3.5 (Flowchart2) "Hilfsmittel".
	case aid
	/// Scene 3.6 (Flowchart2) "Unterstützung".
	case support
	/// Scene 3.9 (Flowchart2) "Erinnerung".
	case reminder
	/// Scene 3.8 (Flowchart2) "Suchfunktion".
	case search
	/// Any ohter scene or non-scene not covered.
	case other

	/**
	 Returns the title for the scene.

	 - returns: The scene's title string.
	 */
	func titleString() -> String {
		switch self {
		case .home:
			return R.string.menu.homeTitle()
		case .doctorVisit:
			return R.string.menu.doctorVisitTitle()
		case .selfTest:
			return R.string.menu.selfTestTitle()
		case .knowledge:
			return R.string.menu.knowledgeTitle()
		case .settings:
			return R.string.menu.settingsTitle()
		case .illness:
			return R.string.menu.illnessTitle()
		case .examination:
			return R.string.menu.examinationTitle()
		case .therapy:
			return R.string.menu.therapyTitle()
		case .activities:
			return R.string.menu.activitiesTitle()
		case .aid:
			return R.string.menu.aidTitle()
		case .support:
			return R.string.menu.supportTitle()
		default:
			fatalError()
		}
	}
}

/// All type of appointments.
@objc enum AppointmentType: Int {
	/// The treatment ("Behandlung") appointment.
	case treatment = 1
	/// The atercare ("Nachsorge") appointment.
	case aftercare
	/// The OCT-check ("OCT-Kontrolle") appointment.
	case octCheck
	/// The other ("Sonstige") appointment.
	case other

	/**
	 Returns the printable string for the appointment.

	 - returns: The appointment's string.
	 */
	func nameString() -> String {
		switch self {
		case .treatment:
			return R.string.global.appointmentTreatment()
		case .aftercare:
			return R.string.global.appointmentAftercare()
		case .octCheck:
			return R.string.global.appointmentOctCheck()
		case .other:
			return R.string.global.appointmentOther()
		}
	}

	/**
	 Returns the speakable string for the appointment.

	 - returns: The appointment's speech synthesizer string.
	 */
	func nameSpeechString() -> String {
		switch self {
		case .treatment:
			return R.string.global.appointmentTreatmentSpeech()
		case .aftercare:
			return R.string.global.appointmentAftercareSpeech()
		case .octCheck:
			return R.string.global.appointmentOctCheckSpeech()
		case .other:
			return R.string.global.appointmentOtherSpeech()
		}
	}

	/**
	 Returns the foreground color for the appointment's cell in default state.

	 - returns: The default color.
	 */
	func defaultColor() -> UIColor {
		switch self {
		case .treatment:
			return Const.Color.green
		case .aftercare:
			return Const.Color.magenta
		case .octCheck:
			return Const.Color.yellow
		case .other:
			return Const.Color.white
		}
	}

	/**
	 Returns the foreground color for the appointment's cell in highlight state.

	 - returns: The highlight color.
	 */
	func highlightColor() -> UIColor {
		switch self {
		case .other:
			return Const.Color.lightMain
		default:
			return Const.Color.white
		}
	}
}

/// All type of contacts.
@objc enum ContactType: Int {
	/// The treatment ("Behandlung") contact.
	case treatment = 1
	/// The atercare ("Nachsorge") contact.
	case aftercare
	/// The OCT-check ("OCT-Kontrolle") contact.
	case octCheck
	/// The AMD-network ("AMD-Netz") contact.
	case amdNet
	/// A user created custom contact.
	case custom

	/**
	 Returns the printable string for the contact's type.
	 Only valid for a non-custom entry (treatment, aftercare, octCheck, amdNet).

	 - returns: The contact type's string.
	 */
	func displayString() -> String {
		switch self {
		case .treatment:
			return R.string.global.contactTreatment()
		case .aftercare:
			return R.string.global.contactAftercare()
		case .octCheck:
			return R.string.global.contactOctCheck()
		case .amdNet:
			return R.string.global.contactAmdNetwork()
		default:
			fatalError()
		}
	}

	/**
	 Returns the speakable string for the contact's type.
	 Only valid for a non-custom entry (treatment, aftercare, octCheck, amdNet).

	 - returns: The contact type's string for a speech synthesizer.
	 */
	func speechString() -> String {
		switch self {
		case .treatment:
			return R.string.global.contactTreatmentSpeech()
		case .aftercare:
			return R.string.global.contactAftercareSpeech()
		case .octCheck:
			return R.string.global.contactOctCheckSpeech()
		case .amdNet:
			return R.string.global.contactAmdNetworkSpeech()
		default:
			fatalError()
		}
	}

	/**
	 Returns the foreground color for the contact's cell in default state.

	 - returns: The default color.
	 */
	func defaultColor() -> UIColor {
		switch self {
		case .treatment:
			return Const.Color.green
		case .aftercare:
			return Const.Color.magenta
		case .octCheck:
			return Const.Color.yellow
		case .amdNet:
			return Const.Color.lightMain
		case .custom:
			return Const.Color.white
		}
	}

	/**
	 Returns the foreground color for the appointment's cell in highlight state.

	 - returns: The highlight color.
	 */
	func highlightColor() -> UIColor {
		switch self {
		case .custom:
			return Const.Color.lightMain
		default:
			return Const.Color.white
		}
	}
}

// swiftlint:disable type_body_length
/// All type of information.
enum InfoType: Int, CaseIterable {
	/// The informaiton for the amslertest.
	case amslertest = 0
	/// The information for the readingtest.
	case readingtest
	/// The information for the visus input scene.
	case visus
	/// The information for the NHD input scene.
	case nhd
	/// The information for the AMD entry in the diagnosis scene.
	case amd
	/// The information for the DMO entry in the diagnosis scene.
	case dmo
	/// The information for the RVV entry in the diagnosis scene.
	case rvv
	/// The information for the mCNV entry in the diagnosis scene.
	case mcnv

	/// `Adressverzeichnis`.
	case addresses
	/// `Aktuelles`.
	case news
	/// `Impressum`.
	case inprint
	/// `Version`.
	case version

	// MARK: settings

	case backup

	// MARK: knowledge

	/// `Bedienung`.
	case manual
	/// `Diagnose`.
	case diagnose

	// MARK: illness

	case illnessInfo0
	case illnessInfo1
	case illnessInfo2
	case illnessInfo3
	case illnessInfo4
	case illnessInfo5
	case illnessInfo6
	case illnessInfo7
	case illnessInfo8
	case illnessInfo9

	// MARK: examination

	case examinationInfo0
	case examinationInfo1
	case examinationInfo2
	case examinationInfo3
	case examinationInfo4
	case examinationInfo5
	case examinationInfo6

	// MARK: therapy

	case therapyInfo0
	case therapyInfo1
	case therapyInfo2
	case therapyInfo3
	case therapyInfo4
	case therapyInfo5

	// MARK: activities

	case activitiesInfo0
	case activitiesInfo1
	case activitiesInfo2
	case activitiesInfo3
	case activitiesInfo4
	case activitiesInfo5

	// MARK: aid

	case aidInfo0
	case aidInfo1
	case aidInfo2
	case aidInfo3
	case aidInfo4
	case aidInfo5
	case aidInfo6
	case aidInfo7

	// MARK: support

	case supportInfo0
	case supportInfo1
	case supportInfo2
	case supportInfo3
	case supportInfo4

	// swiftlint:disable cyclomatic_complexity
	// swiftlint:disable function_body_length
	/**
	 Returns the title for the scene.

	 - returns: The scene's title string.
	 */
	func titleString() -> String {
		switch self {
		case .amslertest:
			return R.string.info.amslertestInfoTitle()
		case .readingtest:
			return R.string.info.readingtestInfoTitle()
		case .visus:
			return R.string.info.visusInfoTitle()
		case .nhd:
			return R.string.info.nhdInfoTitle()
		case .amd:
			return R.string.info.amdInfoTitle()
		case .dmo:
			return R.string.info.dmoInfoTitle()
		case .rvv:
			return R.string.info.rvvInfoTitle()
		case .mcnv:
			return R.string.info.mcnvInfoTitle()
		case .addresses:
			return R.string.info.addressesTitle()
		case .news:
			return R.string.info.newsTitle()
		case .inprint:
			return R.string.info.inprintTitle()
		case .version:
			return R.string.info.versionTitle()
		case .backup:
			return R.string.info.backupTitle()
		case .manual:
			return R.string.info.manualTitle()
		case .diagnose:
			return R.string.info.diagnoseTitle()
		case .illnessInfo0:
			return R.string.info.illnessInfo0Title()
		case .illnessInfo1:
			return R.string.info.illnessInfo1Title()
		case .illnessInfo2:
			return R.string.info.illnessInfo2Title()
		case .illnessInfo3:
			return R.string.info.illnessInfo3Title()
		case .illnessInfo4:
			return R.string.info.illnessInfo4Title()
		case .illnessInfo5:
			return R.string.info.illnessInfo5Title()
		case .illnessInfo6:
			return R.string.info.illnessInfo6Title()
		case .illnessInfo7:
			return R.string.info.illnessInfo7Title()
		case .illnessInfo8:
			return R.string.info.illnessInfo8Title()
		case .illnessInfo9:
			return R.string.info.illnessInfo9Title()
		case .examinationInfo0:
			return R.string.info.examinationInfo0Title()
		case .examinationInfo1:
			return R.string.info.examinationInfo1Title()
		case .examinationInfo2:
			return R.string.info.examinationInfo2Title()
		case .examinationInfo3:
			return R.string.info.examinationInfo3Title()
		case .examinationInfo4:
			return R.string.info.examinationInfo4Title()
		case .examinationInfo5:
			return R.string.info.examinationInfo5Title()
		case .examinationInfo6:
			return R.string.info.examinationInfo6Title()
		case .therapyInfo0:
			return R.string.info.therapyInfo0Title()
		case .therapyInfo1:
			return R.string.info.therapyInfo1Title()
		case .therapyInfo2:
			return R.string.info.therapyInfo2Title()
		case .therapyInfo3:
			return R.string.info.therapyInfo3Title()
		case .therapyInfo4:
			return R.string.info.therapyInfo4Title()
		case .therapyInfo5:
			return R.string.info.therapyInfo5Title()
		case .activitiesInfo0:
			return R.string.info.activitiesInfo0Title()
		case .activitiesInfo1:
			return R.string.info.activitiesInfo1Title()
		case .activitiesInfo2:
			return R.string.info.activitiesInfo2Title()
		case .activitiesInfo3:
			return R.string.info.activitiesInfo3Title()
		case .activitiesInfo4:
			return R.string.info.activitiesInfo4Title()
		case .activitiesInfo5:
			return R.string.info.activitiesInfo5Title()
		case .aidInfo0:
			return R.string.info.aidInfo0Title()
		case .aidInfo1:
			return R.string.info.aidInfo1Title()
		case .aidInfo2:
			return R.string.info.aidInfo2Title()
		case .aidInfo3:
			return R.string.info.aidInfo3Title()
		case .aidInfo4:
			return R.string.info.aidInfo4Title()
		case .aidInfo5:
			return R.string.info.aidInfo5Title()
		case .aidInfo6:
			return R.string.info.aidInfo6Title()
		case .aidInfo7:
			return R.string.info.aidInfo7Title()
		case .supportInfo0:
			return R.string.info.supportInfo0Title()
		case .supportInfo1:
			return R.string.info.supportInfo1Title()
		case .supportInfo2:
			return R.string.info.supportInfo2Title()
		case .supportInfo3:
			return R.string.info.supportInfo3Title()
		case .supportInfo4:
			return R.string.info.supportInfo4Title()
		}
	}

	/**
	 Returns the speech text for the scene.

	 - returns: The string for the speech synthesizer.
	 */
	func speechText() -> String {
		switch self {
		case .amslertest:
			return R.string.info.amslertestSpeechText()
		case .readingtest:
			return R.string.info.readingtestSpeechText()
		case .visus:
			return R.string.info.visusSpeechText()
		case .nhd:
			return R.string.info.nhdSpeechText()
		case .amd:
			return R.string.info.amdSpeechText()
		case .dmo:
			return R.string.info.dmoSpeechText()
		case .rvv:
			return R.string.info.rvvSpeechText()
		case .mcnv:
			return R.string.info.mcnvSpeechText()
		case .addresses:
			return R.string.info.addressesSpeechText()
		case .news:
			return R.string.info.newsSpeechText()
		case .inprint:
			return R.string.info.inprintSpeechText()
		case .version:
			return R.string.info.versionSpeechText()
		case .backup:
			return R.string.info.backupSpeechText()
		case .manual:
			return R.string.info.manualSpeechText()
		case .diagnose:
			return R.string.info.diagnoseSpeechText()
		case .illnessInfo0:
			return R.string.info.illnessInfo0SpeechText()
		case .illnessInfo1:
			return R.string.info.illnessInfo1SpeechText()
		case .illnessInfo2:
			return R.string.info.illnessInfo2SpeechText()
		case .illnessInfo3:
			return R.string.info.illnessInfo3SpeechText()
		case .illnessInfo4:
			return R.string.info.illnessInfo4SpeechText()
		case .illnessInfo5:
			return R.string.info.illnessInfo5SpeechText()
		case .illnessInfo6:
			return R.string.info.illnessInfo6SpeechText()
		case .illnessInfo7:
			return R.string.info.illnessInfo7SpeechText()
		case .illnessInfo8:
			return R.string.info.illnessInfo8SpeechText()
		case .illnessInfo9:
			return R.string.info.illnessInfo9SpeechText()
		case .examinationInfo0:
			return R.string.info.examinationInfo0SpeechText()
		case .examinationInfo1:
			return R.string.info.examinationInfo1SpeechText()
		case .examinationInfo2:
			return R.string.info.examinationInfo2SpeechText()
		case .examinationInfo3:
			return R.string.info.examinationInfo3SpeechText()
		case .examinationInfo4:
			return R.string.info.examinationInfo4SpeechText()
		case .examinationInfo5:
			return R.string.info.examinationInfo5SpeechText()
		case .examinationInfo6:
			return R.string.info.examinationInfo6SpeechText()
		case .therapyInfo0:
			return R.string.info.therapyInfo0SpeechText()
		case .therapyInfo1:
			return R.string.info.therapyInfo1SpeechText()
		case .therapyInfo2:
			return R.string.info.therapyInfo2SpeechText()
		case .therapyInfo3:
			return R.string.info.therapyInfo3SpeechText()
		case .therapyInfo4:
			return R.string.info.therapyInfo4SpeechText()
		case .therapyInfo5:
			return R.string.info.therapyInfo5SpeechText()
		case .activitiesInfo0:
			return R.string.info.activitiesInfo0SpeechText()
		case .activitiesInfo1:
			return R.string.info.activitiesInfo1SpeechText()
		case .activitiesInfo2:
			return R.string.info.activitiesInfo2SpeechText()
		case .activitiesInfo3:
			return R.string.info.activitiesInfo3SpeechText()
		case .activitiesInfo4:
			return R.string.info.activitiesInfo4SpeechText()
		case .activitiesInfo5:
			return R.string.info.activitiesInfo5SpeechText()
		case .aidInfo0:
			return R.string.info.aidInfo0SpeechText()
		case .aidInfo1:
			return R.string.info.aidInfo1SpeechText()
		case .aidInfo2:
			return R.string.info.aidInfo2SpeechText()
		case .aidInfo3:
			return R.string.info.aidInfo3SpeechText()
		case .aidInfo4:
			return R.string.info.aidInfo4SpeechText()
		case .aidInfo5:
			return R.string.info.aidInfo5SpeechText()
		case .aidInfo6:
			return R.string.info.aidInfo6SpeechText()
		case .aidInfo7:
			return R.string.info.aidInfo7SpeechText()
		case .supportInfo0:
			return R.string.info.supportInfo0SpeechText()
		case .supportInfo1:
			return R.string.info.supportInfo1SpeechText()
		case .supportInfo2:
			return R.string.info.supportInfo2SpeechText()
		case .supportInfo3:
			return R.string.info.supportInfo3SpeechText()
		case .supportInfo4:
			return R.string.info.supportInfo4SpeechText()
		}
	}

	/**
	 Returns the content to show.

	 - returns: The content string.
	 */
	func contentString() -> String {
		switch self {
		case .amslertest:
			return R.string.info.amslertestInstruction()
		case .readingtest:
			return R.string.info.readingtestInstruction()
		case .visus:
			return R.string.info.visusInstruction()
		case .nhd:
			return R.string.info.nhdInstruction()
		case .amd:
			return R.string.info.amdInstruction()
		case .dmo:
			return R.string.info.dmoInstruction()
		case .rvv:
			return R.string.info.rvvInstruction()
		case .mcnv:
			return R.string.info.mcnvInstruction()
		case .addresses:
			return R.string.info.addressesInstruction()
		case .news:
			return R.string.info.newsInstruction()
		case .inprint:
			return R.string.info.inprintInstruction()
		case .version:
			return R.string.info.versionInstruction()
		case .backup:
			return R.string.info.backupInstruction()
		case .manual:
			return R.string.info.manualInstruction()
		case .diagnose:
			return R.string.info.diagnoseInstruction()
		case .illnessInfo0:
			return R.string.info.illnessInfo0Instruction()
		case .illnessInfo1:
			return R.string.info.illnessInfo1Instruction()
		case .illnessInfo2:
			return R.string.info.illnessInfo2Instruction()
		case .illnessInfo3:
			return R.string.info.illnessInfo3Instruction()
		case .illnessInfo4:
			return R.string.info.illnessInfo4Instruction()
		case .illnessInfo5:
			return R.string.info.illnessInfo5Instruction()
		case .illnessInfo6:
			return R.string.info.illnessInfo6Instruction()
		case .illnessInfo7:
			return R.string.info.illnessInfo7Instruction()
		case .illnessInfo8:
			return R.string.info.illnessInfo8Instruction()
		case .illnessInfo9:
			return R.string.info.illnessInfo9Instruction()
		case .examinationInfo0:
			return R.string.info.examinationInfo0Instruction()
		case .examinationInfo1:
			return R.string.info.examinationInfo1Instruction()
		case .examinationInfo2:
			return R.string.info.examinationInfo2Instruction()
		case .examinationInfo3:
			return R.string.info.examinationInfo3Instruction()
		case .examinationInfo4:
			return R.string.info.examinationInfo4Instruction()
		case .examinationInfo5:
			return R.string.info.examinationInfo5Instruction()
		case .examinationInfo6:
			return R.string.info.examinationInfo6Instruction()
		case .therapyInfo0:
			return R.string.info.therapyInfo0Instruction()
		case .therapyInfo1:
			return R.string.info.therapyInfo1Instruction()
		case .therapyInfo2:
			return R.string.info.therapyInfo2Instruction()
		case .therapyInfo3:
			return R.string.info.therapyInfo3Instruction()
		case .therapyInfo4:
			return R.string.info.therapyInfo4Instruction()
		case .therapyInfo5:
			return R.string.info.therapyInfo5Instruction()
		case .activitiesInfo0:
			return R.string.info.activitiesInfo0Instruction()
		case .activitiesInfo1:
			return R.string.info.activitiesInfo1Instruction()
		case .activitiesInfo2:
			return R.string.info.activitiesInfo2Instruction()
		case .activitiesInfo3:
			return R.string.info.activitiesInfo3Instruction()
		case .activitiesInfo4:
			return R.string.info.activitiesInfo4Instruction()
		case .activitiesInfo5:
			return R.string.info.activitiesInfo5Instruction()
		case .aidInfo0:
			return R.string.info.aidInfo0Instruction()
		case .aidInfo1:
			return R.string.info.aidInfo1Instruction()
		case .aidInfo2:
			return R.string.info.aidInfo2Instruction()
		case .aidInfo3:
			return R.string.info.aidInfo3Instruction()
		case .aidInfo4:
			return R.string.info.aidInfo4Instruction()
		case .aidInfo5:
			return R.string.info.aidInfo5Instruction()
		case .aidInfo6:
			return R.string.info.aidInfo6Instruction()
		case .aidInfo7:
			return R.string.info.aidInfo7Instruction()
		case .supportInfo0:
			return R.string.info.supportInfo0Instruction()
		case .supportInfo1:
			return R.string.info.supportInfo1Instruction()
		case .supportInfo2:
			return R.string.info.supportInfo2Instruction()
		case .supportInfo3:
			return R.string.info.supportInfo3Instruction()
		case .supportInfo4:
			return R.string.info.supportInfo4Instruction()
		}
	}

	// swiftlint:enable cyclomatic_complexity
	// swiftlint:enable function_body_length
}

// swiftlint:enable type_body_length

/// The model used for text to speech where each model is a piece to speak out.
struct SpeechData {
	/// The text to speak out by the synthesizer.
	var text: String
	/// The index path pointing to the speech data's corresponding cell in a table view.
	var indexPath: IndexPath?
}

/// The visus or NHD type.
enum VisusNhdType {
	/// A Visus value.
	case visus
	/// A NHD value.
	case nhd

	/**
	 Returns the value as a formatted string for its type.
	 This formats only the number, for a formatted output inclusive unit of measurement use `valueOutput`.

	 - parameter value: The value to format.
	 - returns: The formatted string, e.g. "480".
	 */
	func valueString(value: Float) -> String {
		switch self {
		case .visus:
			let visusFormatter = VisusValueFormatter()
			return visusFormatter.string(for: value) ?? String.empty
		case .nhd:
			let nhdFormatter = NhdValueFormatter()
			return nhdFormatter.string(for: value) ?? String.empty
		}
	}

	/**
	 Returns the value as a formatted string inclusive unit of measurement for its type.

	 - parameter value: The value to format.
	 - returns: The formatted string, e.g. "480 µm".
	 */
	func valueOutput(value: Float?) -> String {
		if let value = value {
			switch self {
			case .visus:
				let visusFormatter = VisusValueFormatter()
				let visusValue = visusFormatter.string(for: value) ?? String.empty
				return R.string.global.visusOutput(visusValue)
			case .nhd:
				let nhdFormatter = NhdValueFormatter()
				let nhdValue = nhdFormatter.string(for: value) ?? String.empty
				return R.string.global.nhdOutput(nhdValue)
			}
		} else {
			switch self {
			case .visus:
				return R.string.global.visusOutputNoValue()
			case .nhd:
				return R.string.global.nhdOutputNoValue()
			}
		}
	}

	/// The min value for the type.
	var minValue: Float {
		switch self {
		case .visus:
			return Float(Const.Data.visusMinValue)
		case .nhd:
			return Const.Data.nhdMinValue
		}
	}

	/// The max value for the type.
	var maxValue: Float {
		switch self {
		case .visus:
			return Float(Const.Data.visusMaxValue)
		case .nhd:
			return Const.Data.nhdMaxValue
		}
	}

	/// The value to use for representing the default value, e.g. the middle of all available.
	var middleValue: Float {
		switch self {
		case .visus:
			return (maxValue / 2.0).rounded()
		case .nhd:
			return minValue + ((maxValue - minValue) / 2.0)
		}
	}
}
