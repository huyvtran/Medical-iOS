source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

# Required common pods.
def common_pods
	# Constants for localized text, storyboards, nibs, etc.
	# https://github.com/mac-cain13/R.swift
	pod 'R.swift'
	
	# A logger.
	# https://github.com/CocoaLumberjack/CocoaLumberjack
	pod 'CocoaLumberjack/Swift'

	# UIColor creation with hex values.
	# https://github.com/thii/SwiftHEXColors
	pod 'SwiftHEXColors'

	# A strong typed folder path structure to replace NSSearchPathForDirectoriesInDomains.
	# https://github.com/dreymonde/AppFolder
	pod 'AppFolder'

	# Easy attributed strings in Swift.
	# https://github.com/Raizlabs/BonMot
	pod 'BonMot'
    
	# A collection of operators and utilities that simplify iOS layout code.
	# https://github.com/Raizlabs/Anchorage
	pod 'Anchorage'

	# Easy Dates in Swift.
	# https://github.com/malcommac/SwiftDate
	#pod 'SwiftDate'

	# Intuitive date handling in Swift.
	# https://github.com/naoty/Timepiece
	pod 'Timepiece'

	# Elegant transition library for iOS.
	# https://github.com/lkzhao/Hero
	pod 'Hero'

	# Realm mobile database.
	# https://github.com/realm/realm-cocoa
	pod 'RealmSwift'
    
    # Swipeable UITableViewCell or UICollectionViewCell
    # https://github.com/SwipeCellKit/SwipeCellKit
    pod 'SwipeCellKit'

	# Chart library
	# https://github.com/i-schuetz/SwiftCharts
	pod 'SwiftCharts'

	# Chart library, Swift version of MPAndroidChart.
	# https://github.com/danielgindi/Charts
	#pod 'Charts'
	#pod 'ChartsRealm'

	# Chart library
	# https://github.com/core-plot/core-plot
	#pod 'CorePlot'
    
    # Attributed string library
    # https://github.com/malcommac/SwiftRichString
    pod 'SwiftRichString'

	# A library for zipping and unzipping files.
	# https://github.com/marmelroy/Zip
	pod 'Zip'
	
	# Swift wrapper for accessing the keychain.
	# https://github.com/kishikawakatsumi/KeychainAccess
	#pod 'KeychainAccess'

	# HTTP request handler.
    # https://github.com/Alamofire/Alamofire
    #pod 'Alamofire'

	# Network abstraction layer.
	# https://github.com/Moya/Moya
	# pod 'Moya'

	# JSON handler for Swift.
    # https://github.com/SwiftyJSON/SwiftyJSON
	#pod 'SwiftyJSON'

	# Promises, Async & Await library.
	# https://github.com/malcommac/Hydra
	#pod 'Hydra'
end

# Pods used for development only.
def development_pods
	# A linter to gather code metrics.
	# https://github.com/realm/SwiftLint
	pod 'SwiftLint'

	# Formats the swift code to be consistent.	
    # https://github.com/nicklockwood/SwiftFormat
    pod 'SwiftFormat/CLI'
end

# Pods for Unit testing.
def unittest_pods
	# Mocking framework for Swift.
	# https://github.com/Brightify/Cuckoo
	#pod 'Cuckoo'

	# HTTP request mocker.
	# https://github.com/kylef/Mockingjay/releases
	#pod 'Mockingjay'

	# Snapshot view unit tests.
	# https://github.com/uber/ios-snapshot-test-case
	pod 'iOSSnapshotTestCase'

	# Collection of debugging tools
	# https://github.com/dbukowski/DBDebugToolkit
	#pod 'DBDebugToolkit'
end

# Pods for UI testing.
def uitest_pods
	# Device type detection.
	# https://github.com/dennisweissmann/DeviceKit
	#pod 'DeviceKit'

	# Snapshot view unit tests.
	# https://github.com/uber/ios-snapshot-test-case
	#pod 'iOSSnapshotTestCase'

	# Fake the simulator status bar.
	# Warning: Has many problems with some devices, orientation and older iOS version, so it's not recommendet to use.
	# https://github.com/shinydevelopment/SimulatorStatusMagic
	#pod 'SimulatorStatusMagic'

	# Collection of debugging tools
	# https://github.com/dbukowski/DBDebugToolkit
	#pod 'DBDebugToolkit'
end

# Pods for taking screenshots.
def screenshots_pods
	# Device type detection.
	# https://github.com/dennisweissmann/DeviceKit
	#pod 'DeviceKit'

	# Snapshot view unit tests.
	# https://github.com/uber/ios-snapshot-test-case
	#pod 'iOSSnapshotTestCase'

	# Fake the simulator status bar.
	# Warning: Has many problems with some devices, orientation and older iOS version, so it's not recommendet to use.
	# https://github.com/shinydevelopment/SimulatorStatusMagic
	#pod 'SimulatorStatusMagic'
end


# Targets

target 'Makula' do
	common_pods
	development_pods
end

target 'MakulaUnitTests' do
	common_pods
	unittest_pods
end

target 'MakulaUITests' do
	uitest_pods
end

target 'MakulaScreenshots' do
	screenshots_pods
end

target 'MakulaRelease' do
	common_pods
	development_pods
end


# Post install

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			# Ignore any warnings from pods.
			config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "YES"
			config.build_settings['SWIFT_SUPPRESS_WARNINGS'] = "YES"
		end
	end
end
