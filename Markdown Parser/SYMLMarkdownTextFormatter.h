//
//  SYMLMarkdownTextFormatter.h
//  Syml
//
//  Created by Harry Jordan on 17/01/2013.
//  Copyright (c) 2013 Harry Jordan. All rights reserved.
//
//  Released under the MIT license: http://opensource.org/licenses/mit-license.php
//

#import "SYMLMarkdownParserAttributes.h"
#import "SYMLTextElementsCollection.h"


@interface SYMLMarkdownTextFormatter : NSObject <SYMLMarkdownParserAttributes>

- (SYMLMarkdownTextFormatter *)initWithThemeColors:(NSArray *)themeColors;

- (NSAttributedString *)formatString:(NSString *)inputString;
- (NSAttributedString *)formatString:(NSString *)inputString elements:(SYMLTextElementsCollection **)textElements;

- (SYMLTextElementsCollection *)elementsFromString:(NSString *)inputString;


@property (strong, readonly) NSDictionary *baseAttributes, *headingAttributes, *horizontalRuleAttributes, *blockquoteAttributes, *listElementAttributes, *listLineAttributes, *emphasisAttributes, *strongAttributes, *linkAttributes, *linkTitleAttributes, *linkTagAttributes, *invalidLinkAttributes, *urlAttributes;

@end
