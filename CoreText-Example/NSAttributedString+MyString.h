//
//  NSAttributedString+MyString.h
//  CoreText-Example
//
//  Created by Thibaut Jarosz on 08/09/11.
//  Copyright 2011 Octiplex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>


@interface NSAttributedString (MyString)

// Create a NSAttributedString using the most common attributes
+ (NSAttributedString*)attributedStringWithString:(NSString*)string
                                             font:(UIFont*)font
                                            color:(UIColor*)color
                                             link:(NSURL*)link
                                       underlined:(BOOL)underlined;

// Create a NSAttributedString exemple
+ (NSAttributedString*)myString;

@end
