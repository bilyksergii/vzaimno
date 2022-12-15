//
//  FileUTIWrapper.swift
//  Vzaimno
//
//  Created by Sergii Bilyk on 03.10.2021.
//

import Foundation
import MobileCoreServices

struct FileUTIWrapper {
	static func isAudio(fileName: String) -> Bool {
		guard let uti = utiFrom(fileName: fileName)?.takeRetainedValue() else { return false }
		return UTTypeConformsTo(uti, kUTTypeAudio)
	}

	static func mimeTypeFrom(fileName: String) -> String {
		if let uti = utiFrom(fileName: fileName)?.takeUnretainedValue(),
			let mimeUTI = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType) {
			return "\(mimeUTI.takeRetainedValue())"
		}
		return "text/html"
	}

	private static func utiFrom(fileName: String) -> Unmanaged<CFString>? {
		let ext = (fileName as NSString).pathExtension as CFString
		return UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, ext, nil)
	}
}
