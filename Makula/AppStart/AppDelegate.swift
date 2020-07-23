import AppFolder
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	/// The reference to the window.
	var window: UIWindow?

	/// The global data and any global workers.
	var globalData: GlobalData?

	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
		// If the app is not running 'didFinishLaunchingWithOptions' will be called prior to this method.
		// If the app is running 'applicationWillEnterForeground' is called prior.
		// That makes this call right after the view controller has been loaded and shown.
		guard let globalData = globalData else { return false }
		Log.debug("Open URL: \(url)")

		let fileType = url.pathExtension.lowercased()
		switch fileType {
		case "makula":
			if globalData.dataModelManager.importData(atUrl: url) {
				return true
			}
		default:
			return false
		}
		return false
	}

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Setup logger.
		Log.setup()
		Log.debug("App's home directory:\n" + AppFolder.baseURL.path)
		if CommandLine.arguments.contains(Const.TestArgument.testMode) {
			Log.info("App started in 'testMode'")
		}

		// Create window.
		let window = UIWindow(frame: UIScreen.main.bounds)
		self.window = window

		// Create initial scene.
		let internalSettings = InternalSettings()
		let dataModelManager = DataModelManager()
		let notificationWorker = NotificationWorker()
		let globalData = GlobalData(
			internalSettings: internalSettings,
			dataModelManager: dataModelManager,
			notificationWorker: notificationWorker
		)
		self.globalData = globalData
		let model = SplashRouterModel.Setup(globalData: globalData, commandLineArguments: CommandLine.arguments)
		let splash = SplashDisplay()
		splash.setup(model: model)

		// Route to the initial scene.
		window.rootViewController = splash
		window.makeKeyAndVisible()

		// Make sure the orientation is updated.
		UIDevice.current.beginGeneratingDeviceOrientationNotifications()

		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {}

	func applicationDidEnterBackground(_ application: UIApplication) {}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Reset app to show the spash scene again.
		guard let globalData = globalData else { fatalError() }
		let model = SplashRouterModel.Setup(globalData: globalData, commandLineArguments: [])
		let splash = SplashDisplay()
		splash.setup(model: model)
		window?.rootViewController = splash
	}

	func applicationDidBecomeActive(_ application: UIApplication) {}

	func applicationWillTerminate(_ application: UIApplication) {}
}
