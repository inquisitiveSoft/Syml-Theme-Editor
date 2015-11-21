//
//  SidebarViewController.swift
//  Markdown Parser Example
//
//  Created by Harry Jordan on 19/11/2015.
//  Copyright © 2015 Harry Jordan. All rights reserved.
//

import AppKit


class ThemeViewController: NSViewController, ThemeViewControllerProtocol {
	dynamic var theme: Theme?
	
	@IBOutlet var backgroundView: NSView!
	@IBOutlet weak var identifierField: NSTextField!
	@IBOutlet weak var nameField: NSTextField!
	@IBOutlet weak var attributionField: NSTextField!
	@IBOutlet weak var linkField: NSTextField!
	@IBOutlet weak var colorsTableView: NSTableView!
	
	
	func tableView(tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
		return false
	}

}