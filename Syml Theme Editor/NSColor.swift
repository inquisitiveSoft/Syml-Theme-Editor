//
//  NSColor.swift
//  Syml Theme Editor
//
//  Created by Harry Jordan on 21/11/2015.
//  Copyright © 2015 Inquisitive Software. All rights reserved.
//

import AppKit



extension NSColor {

	func commaSeperatedValues() -> String {
		// Look for RGBA first
		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0
		var alpha: CGFloat = 0
		
		let color = colorUsingColorSpace(NSColorSpace.deviceRGBColorSpace()) ?? .magentaColor()
		color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		
		return String(format: "%.5f, %.5f, %.5f, %.5f", red, green, blue, alpha)
	}

}