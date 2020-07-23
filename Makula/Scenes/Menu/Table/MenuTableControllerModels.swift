import Foundation

/// The menu table cell representations.
enum MenuTableData {
	/// The cell's model to display the main cell and the corresponding cell ID.
	case staticText(StaticTextCellModel, MenuCellIdentifier)
	/// The model for the navigation view as a cell.
	case navigation(NavigationViewCellModel)
}

/// The table controller model of an entry.
struct MenuTableControllerRawEntry {
	/// The cell's title.
	let title: String
	/// Whether the cell's dark style is used or not.
	let darkStyle: Bool
	/// Shows or hides the separator.
	let separatorVisible: Bool
	/// The corresponding scene ID.
	let sceneId: SceneId
}

// swiftlint:disable cyclomatic_complexity
// swiftlint:disable function_body_length
/// All possible cells in the menu with their accessibility identifier as key.
extension MenuCellIdentifier {
	/**
	 Returns the raw cell data of entries for the table cells.

	 - returns: The raw data entry.
	 */
	func rawData() -> MenuTableControllerRawEntry {
		switch self {
		case .doctorVisit:
			return MenuTableControllerRawEntry(title: R.string.menu.homeCell0(), darkStyle: true, separatorVisible: true, sceneId: .doctorVisit)
		case .newAppointment:
			return MenuTableControllerRawEntry(title: R.string.menu.homeCell1(), darkStyle: true, separatorVisible: true, sceneId: .newAppointment)
		case .calendar:
			return MenuTableControllerRawEntry(title: R.string.menu.homeCell2(), darkStyle: true, separatorVisible: true, sceneId: .other)
		case .contactPerson:
			return MenuTableControllerRawEntry(title: R.string.menu.homeCell3(), darkStyle: true, separatorVisible: true, sceneId: .contact)
		case .selfTest:
			return MenuTableControllerRawEntry(title: R.string.menu.homeCell4(), darkStyle: true, separatorVisible: false, sceneId: .selfTest)
		case .knowledge:
			return MenuTableControllerRawEntry(title: R.string.menu.homeCell5(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .addresses:
			return MenuTableControllerRawEntry(title: R.string.menu.homeCell6(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .news:
			return MenuTableControllerRawEntry(title: R.string.menu.homeCell7(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .search:
			return MenuTableControllerRawEntry(title: R.string.menu.homeCell8(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .settings:
			return MenuTableControllerRawEntry(title: R.string.menu.homeCell9(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .inprint:
			return MenuTableControllerRawEntry(title: R.string.menu.homeCell10(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .version:
			let appVersion = Bundle.main.versionNumber
			let buildNumber = Bundle.main.buildNumber
			return MenuTableControllerRawEntry(title: R.string.menu.homeCell11(appVersion, buildNumber), darkStyle: false, separatorVisible: false, sceneId: .other)
		case .manual:
			return MenuTableControllerRawEntry(title: R.string.menu.homeCell12(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .treatment:
			return MenuTableControllerRawEntry(title: R.string.menu.doctorVisitCell0(), darkStyle: true, separatorVisible: true, sceneId: .other)
		case .diagnosis:
			return MenuTableControllerRawEntry(title: R.string.menu.doctorVisitCell1(), darkStyle: true, separatorVisible: true, sceneId: .diagnosis)
		case .medicament:
			return MenuTableControllerRawEntry(title: R.string.menu.doctorVisitCell2(), darkStyle: true, separatorVisible: true, sceneId: .medicament)
		case .visusInput:
			return MenuTableControllerRawEntry(title: R.string.menu.doctorVisitCell3(), darkStyle: true, separatorVisible: true, sceneId: .visusNhdInput)
		case .nhdInput:
			return MenuTableControllerRawEntry(title: R.string.menu.doctorVisitCell4(), darkStyle: true, separatorVisible: true, sceneId: .visusNhdInput)
		case .octVisus:
			return MenuTableControllerRawEntry(title: R.string.menu.doctorVisitCell5(), darkStyle: true, separatorVisible: true, sceneId: .other)
		case .amslerTest:
			return MenuTableControllerRawEntry(title: R.string.menu.selfTestCell0(), darkStyle: true, separatorVisible: true, sceneId: .other)
		case .readingTest:
			return MenuTableControllerRawEntry(title: R.string.menu.selfTestCell1(), darkStyle: true, separatorVisible: true, sceneId: .other)
		case .illness:
			return MenuTableControllerRawEntry(title: R.string.menu.knowledgeCell1(), darkStyle: false, separatorVisible: true, sceneId: .illness)
		case .examination:
			return MenuTableControllerRawEntry(title: R.string.menu.knowledgeCell2(), darkStyle: false, separatorVisible: true, sceneId: .examination)
		case .therapy:
			return MenuTableControllerRawEntry(title: R.string.menu.knowledgeCell3(), darkStyle: false, separatorVisible: true, sceneId: .therapy)
		case .activities:
			return MenuTableControllerRawEntry(title: R.string.menu.knowledgeCell4(), darkStyle: false, separatorVisible: true, sceneId: .activities)
		case .aid:
			return MenuTableControllerRawEntry(title: R.string.menu.knowledgeCell5(), darkStyle: false, separatorVisible: true, sceneId: .aid)
		case .support:
			return MenuTableControllerRawEntry(title: R.string.menu.knowledgeCell6(), darkStyle: false, separatorVisible: true, sceneId: .support)
		case .diagnose:
			return MenuTableControllerRawEntry(title: R.string.menu.knowledgeCell7(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .reminder:
			return MenuTableControllerRawEntry(title: R.string.menu.settingsCell0(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .backup:
			return MenuTableControllerRawEntry(title: R.string.menu.settingsCell1(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .illnessInfo0:
			return MenuTableControllerRawEntry(title: R.string.menu.illnessCell0(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .illnessInfo1:
			return MenuTableControllerRawEntry(title: R.string.menu.illnessCell1(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .illnessInfo2:
			return MenuTableControllerRawEntry(title: R.string.menu.illnessCell2(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .illnessInfo3:
			return MenuTableControllerRawEntry(title: R.string.menu.illnessCell3(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .illnessInfo4:
			return MenuTableControllerRawEntry(title: R.string.menu.illnessCell4(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .illnessInfo5:
			return MenuTableControllerRawEntry(title: R.string.menu.illnessCell5(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .illnessInfo6:
			return MenuTableControllerRawEntry(title: R.string.menu.illnessCell6(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .illnessInfo7:
			return MenuTableControllerRawEntry(title: R.string.menu.illnessCell7(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .illnessInfo8:
			return MenuTableControllerRawEntry(title: R.string.menu.illnessCell8(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .illnessInfo9:
			return MenuTableControllerRawEntry(title: R.string.menu.illnessCell9(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .examinationInfo0:
			return MenuTableControllerRawEntry(title: R.string.menu.examinationCell0(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .examinationInfo1:
			return MenuTableControllerRawEntry(title: R.string.menu.examinationCell1(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .examinationInfo2:
			return MenuTableControllerRawEntry(title: R.string.menu.examinationCell2(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .examinationInfo3:
			return MenuTableControllerRawEntry(title: R.string.menu.examinationCell3(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .examinationInfo4:
			return MenuTableControllerRawEntry(title: R.string.menu.examinationCell4(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .examinationInfo5:
			return MenuTableControllerRawEntry(title: R.string.menu.examinationCell5(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .examinationInfo6:
			return MenuTableControllerRawEntry(title: R.string.menu.examinationCell6(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .therapyInfo0:
			return MenuTableControllerRawEntry(title: R.string.menu.therapyCell0(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .therapyInfo1:
			return MenuTableControllerRawEntry(title: R.string.menu.therapyCell1(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .therapyInfo2:
			return MenuTableControllerRawEntry(title: R.string.menu.therapyCell2(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .therapyInfo3:
			return MenuTableControllerRawEntry(title: R.string.menu.therapyCell3(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .therapyInfo4:
			return MenuTableControllerRawEntry(title: R.string.menu.therapyCell4(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .therapyInfo5:
			return MenuTableControllerRawEntry(title: R.string.menu.therapyCell5(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .activitiesInfo0:
			return MenuTableControllerRawEntry(title: R.string.menu.activitiesCell0(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .activitiesInfo1:
			return MenuTableControllerRawEntry(title: R.string.menu.activitiesCell1(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .activitiesInfo2:
			return MenuTableControllerRawEntry(title: R.string.menu.activitiesCell2(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .activitiesInfo3:
			return MenuTableControllerRawEntry(title: R.string.menu.activitiesCell3(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .activitiesInfo4:
			return MenuTableControllerRawEntry(title: R.string.menu.activitiesCell4(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .activitiesInfo5:
			return MenuTableControllerRawEntry(title: R.string.menu.activitiesCell5(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .aidInfo0:
			return MenuTableControllerRawEntry(title: R.string.menu.aidCell0(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .aidInfo1:
			return MenuTableControllerRawEntry(title: R.string.menu.aidCell1(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .aidInfo2:
			return MenuTableControllerRawEntry(title: R.string.menu.aidCell2(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .aidInfo3:
			return MenuTableControllerRawEntry(title: R.string.menu.aidCell3(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .aidInfo4:
			return MenuTableControllerRawEntry(title: R.string.menu.aidCell4(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .aidInfo5:
			return MenuTableControllerRawEntry(title: R.string.menu.aidCell5(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .aidInfo6:
			return MenuTableControllerRawEntry(title: R.string.menu.aidCell6(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .aidInfo7:
			return MenuTableControllerRawEntry(title: R.string.menu.aidCell7(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .supportInfo0:
			return MenuTableControllerRawEntry(title: R.string.menu.supportCell0(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .supportInfo1:
			return MenuTableControllerRawEntry(title: R.string.menu.supportCell1(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .supportInfo2:
			return MenuTableControllerRawEntry(title: R.string.menu.supportCell2(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .supportInfo3:
			return MenuTableControllerRawEntry(title: R.string.menu.supportCell3(), darkStyle: false, separatorVisible: true, sceneId: .other)
		case .supportInfo4:
			return MenuTableControllerRawEntry(title: R.string.menu.supportCell4(), darkStyle: false, separatorVisible: true, sceneId: .other)
		}
	}

	/**
	 Returns the speech text for the table cells.

	 - returns: The speech text.
	 */
	func speechText() -> String {
		switch self {
		case .doctorVisit:
			return R.string.menu.homeCell0Speech()
		case .newAppointment:
			return R.string.menu.homeCell1Speech()
		case .calendar:
			return R.string.menu.homeCell2Speech()
		case .contactPerson:
			return R.string.menu.homeCell3Speech()
		case .selfTest:
			return R.string.menu.homeCell4Speech()
		case .knowledge:
			return R.string.menu.homeCell5Speech()
		case .addresses:
			return R.string.menu.homeCell6Speech()
		case .news:
			return R.string.menu.homeCell7Speech()
		case .search:
			return R.string.menu.homeCell8Speech()
		case .settings:
			return R.string.menu.homeCell9Speech()
		case .inprint:
			return R.string.menu.homeCell10Speech()
		case .version:
			let appVersion = Bundle.main.versionNumber
			let buildNumber = Bundle.main.buildNumber
			return R.string.menu.homeCell11Speech(appVersion, buildNumber)
		case .manual:
			return R.string.menu.homeCell12Speech()
		case .treatment:
			return R.string.menu.doctorVisitCell0Speech()
		case .diagnosis:
			return R.string.menu.doctorVisitCell1Speech()
		case .medicament:
			return R.string.menu.doctorVisitCell2Speech()
		case .visusInput:
			return R.string.menu.doctorVisitCell3Speech()
		case .nhdInput:
			return R.string.menu.doctorVisitCell4Speech()
		case .octVisus:
			return R.string.menu.doctorVisitCell5Speech()
		case .amslerTest:
			return R.string.menu.selfTestCell0Speech()
		case .readingTest:
			return R.string.menu.selfTestCell1Speech()
		case .illness:
			return R.string.menu.knowledgeCell1Speech()
		case .examination:
			return R.string.menu.knowledgeCell2Speech()
		case .therapy:
			return R.string.menu.knowledgeCell3Speech()
		case .activities:
			return R.string.menu.knowledgeCell4Speech()
		case .aid:
			return R.string.menu.knowledgeCell5Speech()
		case .support:
			return R.string.menu.knowledgeCell6Speech()
		case .diagnose:
			return R.string.menu.knowledgeCell7Speech()
		case .reminder:
			return R.string.menu.settingsCell0Speech()
		case .backup:
			return R.string.menu.settingsCell1Speech()
		case .illnessInfo0:
			return R.string.menu.illnessCell0()
		case .illnessInfo1:
			return R.string.menu.illnessCell1()
		case .illnessInfo2:
			return R.string.menu.illnessCell2()
		case .illnessInfo3:
			return R.string.menu.illnessCell3()
		case .illnessInfo4:
			return R.string.menu.illnessCell4()
		case .illnessInfo5:
			return R.string.menu.illnessCell5()
		case .illnessInfo6:
			return R.string.menu.illnessCell6()
		case .illnessInfo7:
			return R.string.menu.illnessCell7()
		case .illnessInfo8:
			return R.string.menu.illnessCell8()
		case .illnessInfo9:
			return R.string.menu.illnessCell9()
		case .examinationInfo0:
			return R.string.menu.examinationCell0()
		case .examinationInfo1:
			return R.string.menu.examinationCell1()
		case .examinationInfo2:
			return R.string.menu.examinationCell2()
		case .examinationInfo3:
			return R.string.menu.examinationCell3()
		case .examinationInfo4:
			return R.string.menu.examinationCell4()
		case .examinationInfo5:
			return R.string.menu.examinationCell5()
		case .examinationInfo6:
			return R.string.menu.examinationCell6()
		case .therapyInfo0:
			return R.string.menu.therapyCell0()
		case .therapyInfo1:
			return R.string.menu.therapyCell1()
		case .therapyInfo2:
			return R.string.menu.therapyCell2()
		case .therapyInfo3:
			return R.string.menu.therapyCell3()
		case .therapyInfo4:
			return R.string.menu.therapyCell4()
		case .therapyInfo5:
			return R.string.menu.therapyCell5()
		case .activitiesInfo0:
			return R.string.menu.activitiesCell0()
		case .activitiesInfo1:
			return R.string.menu.activitiesCell1()
		case .activitiesInfo2:
			return R.string.menu.activitiesCell2()
		case .activitiesInfo3:
			return R.string.menu.activitiesCell3()
		case .activitiesInfo4:
			return R.string.menu.activitiesCell4()
		case .activitiesInfo5:
			return R.string.menu.activitiesCell5()
		case .aidInfo0:
			return R.string.menu.aidCell0()
		case .aidInfo1:
			return R.string.menu.aidCell1()
		case .aidInfo2:
			return R.string.menu.aidCell2()
		case .aidInfo3:
			return R.string.menu.aidCell3()
		case .aidInfo4:
			return R.string.menu.aidCell4()
		case .aidInfo5:
			return R.string.menu.aidCell5()
		case .aidInfo6:
			return R.string.menu.aidCell6()
		case .aidInfo7:
			return R.string.menu.aidCell7()
		case .supportInfo0:
			return R.string.menu.supportCell0()
		case .supportInfo1:
			return R.string.menu.supportCell1()
		case .supportInfo2:
			return R.string.menu.supportCell2()
		case .supportInfo3:
			return R.string.menu.supportCell3()
		case .supportInfo4:
			return R.string.menu.supportCell4()
		}
	}
}

// swiftlint:enable function_body_length
// swiftlint:enable cyclomatic_complexity
