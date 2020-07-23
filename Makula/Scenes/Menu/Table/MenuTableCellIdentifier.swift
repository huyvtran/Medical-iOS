/// All possible cells in the menu with their accessibility identifier as key.
enum MenuCellIdentifier: String {
	// MARK: root menu

	/// `Arztbesuch`.
	case doctorVisit = "MenuCellDoctorVisit"
	/// `Termine`.
	case newAppointment = "MenuCellNewAppointment"
	/// `Kalender`.
	case calendar = "MenuCellCalendar"
	/// `Kontakte`.
	case contactPerson = "MenuCellContactPerson"
	/// `Selbsttest`.
	case selfTest = "MenuCellSelfTest"
	/// `Wissen/Information`.
	case knowledge = "MenuCellKnowledge"
	/// `Adressverzeichnis`.
	case addresses = "MenuCellAddresses"
	/// `Aktuelles`.
	case news = "MenuCellNews"
	/// `Suchfunktion`.
	case search = "MenuCellSearch"
	/// `Einstellungen`.
	case settings = "MenuCellSettings"
	/// `Impressum`.
	case inprint = "MenuCellInprint"
	/// `Version`.
	case version = "MenuCellVersion"

	// MARK: doctorVisit

	/// The date of the last treatment (`Behandlung`).
	case treatment = "MenuCellTreatment"
	/// `Diagnose`.
	case diagnosis = "MenuCellDiagnosis"
	/// `Medikamente`.
	case medicament = "MenuCellMedicament"
	/// `Visus-Eingabe`.
	case visusInput = "MenuCellVisusInput"
	/// `NH-Dicke-Eingabe`.
	case nhdInput = "MenuCellNHDInput"
	/// `OCT/Visus`.
	case octVisus = "MenuCellOctVisus"

	// MARK: selfTest

	/// `Amslertest`.
	case amslerTest = "MenuCellAmslerTest"
	/// `Lesetest`.
	case readingTest = "MenuCellReadingTest"

	// MARK: knowledge

	/// `Bedienung`.
	case manual = "MenuCellManual"
	/// `Erkrankung`.
	case illness = "MenuCellIllness"
	/// `Untersuchung`.
	case examination = "MenuCellExamination"
	/// `Therapie`.
	case therapy = "MenuCellTherapy"
	/// `Maßnahmen`.
	case activities = "MenuCellActivities"
	/// `Hilfsmittel`.
	case aid = "MenuCellAid"
	/// `Unterstützung`.
	case support = "MenuCellSupport"
	/// `Diagnose`.
	case diagnose = "MenuCellDiagnose"

	// MARK: settings

	/// `Erinnerung`.
	case reminder = "MenuCellReminder"
	/// `Backup`.
	case backup = "MenuCellBackup"

	// MARK: illness

	case illnessInfo0 = "MenuCellIllnessInfo0"
	case illnessInfo1 = "MenuCellIllnessInfo1"
	case illnessInfo2 = "MenuCellIllnessInfo2"
	case illnessInfo3 = "MenuCellIllnessInfo3"
	case illnessInfo4 = "MenuCellIllnessInfo4"
	case illnessInfo5 = "MenuCellIllnessInfo5"
	case illnessInfo6 = "MenuCellIllnessInfo6"
	case illnessInfo7 = "MenuCellIllnessInfo7"
	case illnessInfo8 = "MenuCellIllnessInfo8"
	case illnessInfo9 = "MenuCellIllnessInfo9"

	// MARK: examination

	case examinationInfo0 = "MenuCellExaminationInfo0"
	case examinationInfo1 = "MenuCellExaminationInfo1"
	case examinationInfo2 = "MenuCellExaminationInfo2"
	case examinationInfo3 = "MenuCellExaminationInfo3"
	case examinationInfo4 = "MenuCellExaminationInfo4"
	case examinationInfo5 = "MenuCellExaminationInfo5"
	case examinationInfo6 = "MenuCellExaminationInfo6"

	// MARK: therapy

	case therapyInfo0 = "MenuCellTherapyInfo0"
	case therapyInfo1 = "MenuCellTherapyInfo1"
	case therapyInfo2 = "MenuCellTherapyInfo2"
	case therapyInfo3 = "MenuCellTherapyInfo3"
	case therapyInfo4 = "MenuCellTherapyInfo4"
	case therapyInfo5 = "MenuCellTherapyInfo5"

	// MARK: activities

	case activitiesInfo0 = "MenuCellActivitiesInfo0"
	case activitiesInfo1 = "MenuCellActivitiesInfo1"
	case activitiesInfo2 = "MenuCellActivitiesInfo2"
	case activitiesInfo3 = "MenuCellActivitiesInfo3"
	case activitiesInfo4 = "MenuCellActivitiesInfo4"
	case activitiesInfo5 = "MenuCellActivitiesInfo5"

	// MARK: aid

	case aidInfo0 = "MenuCellAidInfo0"
	case aidInfo1 = "MenuCellAidInfo1"
	case aidInfo2 = "MenuCellAidInfo2"
	case aidInfo3 = "MenuCellAidInfo3"
	case aidInfo4 = "MenuCellAidInfo4"
	case aidInfo5 = "MenuCellAidInfo5"
	case aidInfo6 = "MenuCellAidInfo6"
	case aidInfo7 = "MenuCellAidInfo7"

	// MARK: support

	case supportInfo0 = "MenuCellSupportInfo0"
	case supportInfo1 = "MenuCellSupportInfo1"
	case supportInfo2 = "MenuCellSupportInfo2"
	case supportInfo3 = "MenuCellSupportInfo3"
	case supportInfo4 = "MenuCellSupportInfo4"
}
