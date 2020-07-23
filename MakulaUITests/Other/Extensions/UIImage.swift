import UIKit

extension UIImage {
	/**
	 Returns a new image with the top part removed where the status bar would be.

	 - parameter statusBarHeight: The height of the status bar which has to be removed from the image.
	 - returns: The cropped image.
	 */
	func removeStatusBar(withHeight statusBarHeight: CGFloat) -> UIImage {
		guard let cgImage = cgImage else {
			fatalError("Expecting CGImage data")
		}

		let yOffset = statusBarHeight * scale
		let rect = CGRect(x: 0, y: Int(yOffset), width: cgImage.width, height: cgImage.height - Int(yOffset))
		guard let croppedCGImage = cgImage.cropping(to: rect) else {
			fatalError("Error while cropping the image")
		}

		return UIImage(cgImage: croppedCGImage, scale: scale, orientation: imageOrientation)
	}
}
