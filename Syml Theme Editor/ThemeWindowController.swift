//
//  ThemeWindowController.swift
//  Syml Theme Editor
//
//  Created by Harry Jordan on 21/11/2015.
//  Copyright © 2015 Inquisitive Software. All rights reserved.
//

import AppKit


protocol ThemeViewControllerProtocol {
	var theme: Theme? {get set}
}


class ThemeWindowController: NSWindowController {
	var theme: Theme? {
		didSet {
			if var themeViewController = contentViewController as? ThemeViewControllerProtocol {
				themeViewController.theme = theme
			}
		}
	}
	
	override func windowDidLoad() {
		super.windowDidLoad()
		
		window?.setContentSize(NSSize(width: 880.0, height: 560.0))
	}
	
	
	override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
		super.prepareForSegue(segue, sender: sender)
		
	}
	
}


class ThemeSplitViewController: NSSplitViewController, ThemeViewControllerProtocol {
	dynamic var theme: Theme? {
		didSet {
			for splitViewItem in splitViewItems {
				if var themeViewController = splitViewItem.viewController as? ThemeViewControllerProtocol {
					themeViewController.theme = theme
				}
			}
		}
	}
	
}