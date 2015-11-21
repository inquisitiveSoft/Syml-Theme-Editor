//
//  Theme.swift
//  Syml Theme Editor
//
//  Created by Harry Jordan on 20/11/2015.
//  Copyright © 2015 Inquisitive Software. All rights reserved.
//

import AppKit


let colorLabels: [String] = [
	"backgroundColor",
	"baseColor",
	"borderColor",
	"selectedButtonColor",
	"titleColor",
	"headingColor",
	"horizontalRuleColor",
	"emphasisColor",
	"strongColor",
	"blockquoteColor",
	
	"listBulletColor",
	"listLineColor",
	
	"listTaskBulletColor",
	"listTaskLineColor",
	"listTaskBracketsColor",
	
	"listTaskCompletedBulletColor",
	"listTaskCompletedLineColor",
	"listTaskCompletedBracketsColor",
	"listTaskCompletedSpecifierColor",
	
	"linkColor",
	"urlColor",
	"linkTagColor",
	
	"commentColor",
	
	"selectionColor",
	"caretColor",
	"selectionHandleColor",
	
	"actionOverlayColor",
	"insertionBackgroundColor",
	"deletionBackgroundColor"
]


class ThemeColor: NSObject {
	var label: String?
	var color: NSColor?
}



class Theme: NSDocument {

	override func makeWindowControllers() {
		if let windowController = NSStoryboard(name: "Theme Window", bundle: nil).instantiateInitialController() as? ThemeWindowController {
			windowController.theme = self
			addWindowController(windowController)
		}
	}
	
	
	override func readFromData(data: NSData, ofType typeName: String) throws {
		if let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] {
			
		}
	}
	
	
	override func dataOfType(typeName: String) throws -> NSData {
		return NSData()
	}
	
	
	dynamic var themeIdentifier: String? = ""
	dynamic var themeName: String? = ""
	dynamic var attributionName: String? = ""
	dynamic var attributionText: String? = ""
	dynamic var attributionLink: String? = ""
	
	dynamic var colorsArrayController: NSArrayController = {
		let colorsArrayController = NSArrayController()
		let colors = colorLabels.map { (label: String) -> ThemeColor in
			let color = ThemeColor()
			color.label = label
			color.color = .orangeColor()
			return color
		}
		
		colorsArrayController.addObjects(colors)
		return colorsArrayController
	}()

	
	var markdownTextFormatter: SYMLMarkdownTextFormatter {
		get {
			if let themeColors = colorsArrayController.arrangedObjects as? [ThemeColor] {
				return SYMLMarkdownTextFormatter(themeColors: themeColors)
			}
			
			return SYMLMarkdownTextFormatter()
		}
	}

}