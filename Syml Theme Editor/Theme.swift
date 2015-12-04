//
//  Theme.swift
//  Syml Theme Editor
//
//  Created by Harry Jordan on 20/11/2015.
//  Copyright © 2015 Inquisitive Software. All rights reserved.
//

import AppKit

enum ThemeColorLabel: String {
	case backgroundColor, baseColor, borderColor, selectedButtonColor, titleColor, headingColor, horizontalRuleColor, emphasisColor, strongColor, blockquoteColor, listBulletColor, listLineColor, listTaskBulletColor, listTaskLineColor, listTaskBracketsColor, listTaskCompletedBulletColor, listTaskCompletedLineColor, listTaskCompletedBracketsColor, listTaskCompletedSpecifierColor, linkColor, urlColor, invalidLinkColor, linkTagColor, commentColor, selectionColor, caretColor, selectionHandleColor, actionOverlayColor, insertionBackgroundColor, deletionBackgroundColor
}



let colorLabels: [String] = [
	ThemeColorLabel.backgroundColor.rawValue,
	ThemeColorLabel.baseColor.rawValue,
	ThemeColorLabel.borderColor.rawValue,
	ThemeColorLabel.selectedButtonColor.rawValue,
	ThemeColorLabel.titleColor.rawValue,
	ThemeColorLabel.headingColor.rawValue,
	ThemeColorLabel.horizontalRuleColor.rawValue,
	ThemeColorLabel.emphasisColor.rawValue,
	ThemeColorLabel.strongColor.rawValue,
	ThemeColorLabel.blockquoteColor.rawValue,
	
	ThemeColorLabel.listBulletColor.rawValue,
	ThemeColorLabel.listLineColor.rawValue,
	
	ThemeColorLabel.listTaskBulletColor.rawValue,
	ThemeColorLabel.listTaskLineColor.rawValue,
	ThemeColorLabel.listTaskBracketsColor.rawValue,
	
	ThemeColorLabel.listTaskCompletedBulletColor.rawValue,
	ThemeColorLabel.listTaskCompletedLineColor.rawValue,
	ThemeColorLabel.listTaskCompletedBracketsColor.rawValue,
	ThemeColorLabel.listTaskCompletedSpecifierColor.rawValue,
	
	ThemeColorLabel.linkColor.rawValue,
	ThemeColorLabel.urlColor.rawValue,
	ThemeColorLabel.invalidLinkColor.rawValue,
	ThemeColorLabel.linkTagColor.rawValue,
	
	ThemeColorLabel.commentColor.rawValue,
	
	ThemeColorLabel.selectionColor.rawValue,
	ThemeColorLabel.caretColor.rawValue,
	ThemeColorLabel.selectionHandleColor.rawValue,
	
	ThemeColorLabel.actionOverlayColor.rawValue,
	ThemeColorLabel.insertionBackgroundColor.rawValue,
	ThemeColorLabel.deletionBackgroundColor.rawValue
]


@objc class ThemeColor: NSObject {
	convenience init(label: String, color: NSColor) {
		self.init()
		
		self.label = label
		self.color = color
	}

	var label: String?
	var color: NSColor?
}


class Theme: NSDocument {
	dynamic var themeIdentifier: String? = ""
	dynamic var themeName: String? = ""
	dynamic var attributionName: String? = ""
	dynamic var attributionText: String? = ""
	dynamic var attributionLink: String? = ""
	
	dynamic var colorsArrayController: NSArrayController = {
		let colorsArrayController = NSArrayController()
		let colors = colorLabels.map { (label: String) -> ThemeColor in
			switch label {
				case ThemeColorLabel.backgroundColor.rawValue:
					return ThemeColor(label: label, color: .whiteColor())
				
				case ThemeColorLabel.selectionColor.rawValue:
					return ThemeColor(label: label, color: NSColor(calibratedRed:0.426, green:0.727, blue:0.734, alpha:1.000))
				
				case ThemeColorLabel.caretColor.rawValue:
					return ThemeColor(label: label, color: .grayColor())
				
				default:
					return ThemeColor(label: label, color: .blackColor())
			}
		}
		
		colorsArrayController.content = colors
		return colorsArrayController
	}()
}




extension Theme {
	// Theme properties
	
	var markdownTextFormatter: SYMLMarkdownTextFormatter {
		get {
			if let themeColors = colorsArrayController.arrangedObjects as? [ThemeColor] {
				return SYMLMarkdownTextFormatter(themeColors: themeColors)
			}
			
			return SYMLMarkdownTextFormatter()
		}
	}
	
	var backgroundColor: NSColor {
		return colorForKey(ThemeColorLabel.backgroundColor.rawValue)
	}

	
	var caretColor: NSColor {
		return colorForKey(ThemeColorLabel.caretColor.rawValue)
	}
	
	var borderColor: NSColor {
		return colorForKey(ThemeColorLabel.borderColor.rawValue)
	}

	var selectionColor: NSColor {
		return colorForKey(ThemeColorLabel.selectionColor.rawValue)
	}
	
	
	func colorForKey(key: String) -> NSColor {
		if let colors = colorsArrayController.content as? [ThemeColor] {
			for themeColor in colors where themeColor.label == key {
				if let color = themeColor.color {
					return color
				}
			}
		}
		
		return .magentaColor()
	}
}





extension Theme {
	// Instantiation, reading and writing
	
	override func makeWindowControllers() {
		if let windowController = NSStoryboard(name: "Theme Window", bundle: nil).instantiateInitialController() as? ThemeWindowController {
			windowController.theme = self
			addWindowController(windowController)
		}
	}
	
	
	override func readFromData(data: NSData, ofType typeName: String) throws {
		if let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] {
			themeIdentifier = json["identifier"] as? String ?? ""
			themeName = json["name"] as? String ?? ""
			attributionName = json["attribution"] as? String ?? ""
			attributionText = json["attributionText"] as? String ?? ""
			attributionLink = json["url"] as? String ?? ""
			
			let colors = colorLabels.map { (colorLabel: String) -> ThemeColor in
				var color: NSColor = .magentaColor()
				
				if let colorComponents = json[colorLabel] as? [CGFloat] where colorComponents.count >= 4 {
					color = NSColor(calibratedRed: colorComponents[0], green: colorComponents[1], blue: colorComponents[2], alpha: colorComponents[3])
				}
				
				return ThemeColor(label: colorLabel, color: color)
			}
			
			colorsArrayController.content = colors
			colorsArrayController.addObserver(self, forKeyPath: "arrangedObjects.color", options: [], context: nil)
		}
	}
	
	
	override func dataOfType(typeName: String) throws -> NSData {
		guard let templateFileURL = NSBundle.mainBundle().URLForResource("Template", withExtension: "symlTheme") else {
			throw NSError(domain: "theme.document.save.error", code: 0, userInfo: [
				NSLocalizedDescriptionKey : "Couldn't load template file"
			])
		}
		
		var templateString = try NSString(contentsOfURL: templateFileURL, usedEncoding: nil)
		templateString = templateString.stringByReplacingOccurrencesOfString("{{themeIdentifier}}", withString: themeIdentifier ?? "")
		templateString = templateString.stringByReplacingOccurrencesOfString("{{themeName}}", withString: themeName ?? "")
		templateString = templateString.stringByReplacingOccurrencesOfString("{{attributionName}}", withString: attributionName ?? "")
		templateString = templateString.stringByReplacingOccurrencesOfString("{{attributionText}}", withString: attributionText ?? "")
		templateString = templateString.stringByReplacingOccurrencesOfString("{{attributionLink}}", withString: attributionLink ?? "")
		
		
		if let colors = colorsArrayController.arrangedObjects as? [ThemeColor] {
			var isFirstItem = true
			var colorsString = ""
			
			for themeColor in colors {
				guard let label = themeColor.label, color = themeColor.color else {
					continue
				}
					
				if !isFirstItem {
					colorsString += ",\n"
				}
				
				colorsString += "    \"" + label + "\" : [\(color.commaSeperatedValues())]"
				isFirstItem = false
			}
			
			templateString = templateString.stringByReplacingOccurrencesOfString("{{themeColors}}", withString: colorsString)
		}
		
		if let data = templateString.dataUsingEncoding(NSUTF8StringEncoding) {
			return data
		}
		
		throw NSError(domain: "theme.document.save.error", code: 1, userInfo: [
			 NSLocalizedDescriptionKey : "Couldn't save data from string: \(templateString)"
		])
	}
	
	
	override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		updateChangeCount(.ChangeDone)
	}

}