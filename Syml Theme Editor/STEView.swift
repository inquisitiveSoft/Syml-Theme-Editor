//
//  STEView.swift
//  Syml Theme Editor
//
//  Created by Harry Jordan on 21/11/2015.
//  Copyright © 2015 Inquisitive Software. All rights reserved.
//

import AppKit


class STEView: NSView {
	var backgroundColor: NSColor = .whiteColor() {
		didSet {
			setNeedsDisplayInRect(bounds)
		}
	}
	
	
	override func drawRect(rect: NSRect) {
		backgroundColor.setFill()
		NSRectFill(rect)
	}


}