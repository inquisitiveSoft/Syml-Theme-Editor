//
//  TextViewController.swift
//  Markdown Parser Example
//
//  Created by Harry Jordan on 19/11/2015.
//  Copyright © 2015 Harry Jordan. All rights reserved.
//

import AppKit


let colorsArrayKey = "arrangedObjects.color"
let colorsObserverContext = "observe.colors"


class TextViewController: NSViewController, NSTextViewDelegate, ThemeViewControllerProtocol {
	@IBOutlet var textView: NSTextView!
	dynamic var theme: Theme? {
		didSet {
			theme?.colorsArrayController.addObserver(self, forKeyPath: colorsArrayKey, options: [], context: nil)
			applySyntaxHighlighting()
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		textView.textContainerInset = NSMakeSize(60.0, 35.0)
		
		if let exampleDocumentURL = NSBundle.mainBundle().URLForResource("README", withExtension: "md") {
			textView.string = (try? String(contentsOfURL: exampleDocumentURL)) ?? ""
		}
	}
	
	
	override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		guard let keyPath = keyPath else {
			return
		}
		
		switch keyPath {
			case colorsArrayKey:
				applySyntaxHighlighting()
			
			default:
				break
		}
	}
	

	func textDidChange(notification: NSNotification) {
		applySyntaxHighlighting()
	}
	
	
	func applySyntaxHighlighting() {
		if let theme = theme {
			let selectedRange = textView.selectedRange()
			let attributedString = theme.markdownTextFormatter.formatString(textView.string)
			textView.textStorage?.setAttributedString(attributedString)
			textView.setSelectedRange(selectedRange)
		}
	}

}