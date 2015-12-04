//
//  SYMLMarkdownTextFormatter.m
//  Syml
//
//  Created by Harry Jordan on 17/01/2013.
//  Copyright (c) 2013 Harry Jordan. All rights reserved.
//
//  Released under the MIT license: http://opensource.org/licenses/mit-license.php
//


#import "SYMLMarkdownTextFormatter.h"
#import "SYMLMarkdownParser.h"

#import "SYMLAttributedObjectCollection.h"
#import "SYMLTextElementsCollection.h"

#import "NSMutableAttributedString+RangeForAttributedString.h"

#include "TargetConditionals.h"
#import "Syml_Theme_Editor-Swift.h"


@import AppKit;
@import CoreText;



@implementation SYMLMarkdownTextFormatter


- (SYMLMarkdownTextFormatter *)initWithThemeColors:(NSArray *)themeColors
{
	self = [super init];
	
	if(self) {
		NSFont *baseFont = [NSFont fontWithName:@"Menlo" size:14.0];
		NSFont *headingFont = [NSFont fontWithName:@"Menlo Bold" size:18.0];
		NSFont *boldFont = [NSFont fontWithName:@"Menlo Bold" size:14.0];

		NSMutableParagraphStyle *baseParagraphStyle = [[NSMutableParagraphStyle alloc] init];
		baseParagraphStyle.lineHeightMultiple = 1.25;
	
		NSMutableParagraphStyle *headingParagraphStyle = [[NSMutableParagraphStyle alloc] init];
		headingParagraphStyle.lineHeightMultiple = 1.6;
		headingParagraphStyle.lineSpacing = 8.0;
		
		NSMutableDictionary *colorsDictionary = [[NSMutableDictionary alloc] initWithCapacity:themeColors.count];
		
		for(ThemeColor *color in themeColors) {
			colorsDictionary[color.label] = color.color;
		}
		
		
		
		_baseAttributes = @{
			NSFontAttributeName							: baseFont,
			NSForegroundColorAttributeName				: colorsDictionary[@"baseColor"],
			NSParagraphStyleAttributeName				: baseParagraphStyle
		};
	
		_headingAttributes = @{
			NSFontAttributeName							: headingFont,
			NSForegroundColorAttributeName				: colorsDictionary[@"headingColor"],
			NSParagraphStyleAttributeName				: headingParagraphStyle
		};
		
		_horizontalRuleAttributes = @{
			NSFontAttributeName							: baseFont,
			NSForegroundColorAttributeName				: colorsDictionary[@"horizontalRuleColor"],
		};
	
		_blockquoteAttributes = @{
			NSFontAttributeName							: baseFont,
			NSForegroundColorAttributeName				: colorsDictionary[@"blockquoteColor"],
		};
	
		_listElementAttributes = @{
			NSFontAttributeName							: baseFont,
			NSForegroundColorAttributeName				: colorsDictionary[@"listBulletColor"],
		};
		
		_listLineAttributes = @{
			NSFontAttributeName							: baseFont,
			NSForegroundColorAttributeName				: colorsDictionary[@"listLineColor"],
		};
	
		_linkAttributes = @{
			NSFontAttributeName							: baseFont,
			NSForegroundColorAttributeName				: colorsDictionary[@"linkColor"],
		};
		
		_invalidLinkAttributes = @{
			NSFontAttributeName							: baseFont,
			NSForegroundColorAttributeName				: colorsDictionary[@"invalidLinkColor"],
		};
		
		_urlAttributes = @{
		   NSFontAttributeName							: baseFont,
		   NSForegroundColorAttributeName				: colorsDictionary[@"urlColor"],
		   NSUnderlineStyleAttributeName				: @(NSUnderlineStyleSingle)
		};
		
		_linkTagAttributes = @{
		   NSFontAttributeName							: baseFont,
		   NSForegroundColorAttributeName				: colorsDictionary[@"linkTagColor"],
		   NSUnderlineStyleAttributeName				: @(NSUnderlineStyleSingle)
		};
	
		_emphasisAttributes = @{
			NSFontAttributeName							: baseFont,
			NSForegroundColorAttributeName				: colorsDictionary[@"emphasisColor"],
		};

		_strongAttributes = @{
			NSFontAttributeName							: boldFont,
			NSForegroundColorAttributeName				: colorsDictionary[@"strongColor"],
		};
	}
	
	return self;
}


#pragma mark -

- (NSAttributedString *)formatString:(NSString *)inputString
{
	NSMutableAttributedString *formattedText = [[NSMutableAttributedString alloc] initWithString:inputString attributes:[self baseAttributes]];
	[self parseString:inputString intoAttributedCollection:&formattedText];
	
	return formattedText;
}


- (NSAttributedString *)formatString:(NSString *)inputString elements:(SYMLTextElementsCollection **)textElements
{
	SYMLTextElementsCollection *attributesCollection = [[SYMLTextElementsCollection alloc] initWithAttributedString:inputString withAttributes:[self baseAttributes]];
	[self parseString:inputString intoAttributedCollection:&attributesCollection];
	
	if(textElements != NULL) {
		*textElements = attributesCollection;
	}
	
	return [attributesCollection attributedString];
}



- (SYMLTextElementsCollection *)elementsFromString:(NSString *)inputString
{
	SYMLTextElementsCollection *attributesCollection = [[SYMLTextElementsCollection alloc] initWithString:inputString];
	[self parseString:inputString intoAttributedCollection:&attributesCollection];
	
	return attributesCollection;
}



#pragma mark - Parsing the markdown


- (BOOL)parseString:(NSString *)inputString intoAttributedCollection:(id <SYMLAttributedObjectCollection> *)attributesCollection
{
	if(!attributesCollection || !inputString || [inputString length] == 0)
		return FALSE;
	
	
	SYMLMarkdownParserState parseState = SYMLDefaultMarkdownParserState();
	
	// Set any custom parser options here
	
	SYMLParseMarkdown(inputString, attributesCollection, parseState, self);
	
	return TRUE;
}


@end


