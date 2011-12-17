//
//  NSAttributedString+MyString.m
//  CoreText-Example
//
//  Created by Thibaut Jarosz on 08/09/11.
//  Copyright 2011 Octiplex. All rights reserved.
//

#import "NSAttributedString+MyString.h"
#import "CoreTextView.h"


@implementation NSAttributedString (MyString)

+ (NSAttributedString*)attributedStringWithString:(NSString*)string
                                             font:(UIFont*)font
                                            color:(UIColor*)color
                                             link:(NSURL*)link
                                       underlined:(BOOL)underlined
{
    // Creating attributes dictionary
    NSMutableDictionary *attributes = [[[NSMutableDictionary alloc] init] autorelease];
    
    if (font) {
        // Transforming UIFont to CGFont
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
        [attributes setValue:(id)fontRef forKey:(NSString*)kCTFontAttributeName];
        CFRelease(fontRef);
    }
    
    if (color)
        // Transforming UIColor to CGColor
        [attributes setValue:(id)color.CGColor forKey:(NSString*)kCTForegroundColorAttributeName];
    
    if (link)
        // Adding link using the key from CoreTextView
        [attributes setValue:link forKey:(NSString*)kCoreTextViewLinkAttributeName];
    
    if (underlined)
        // Setting the text underline
        [attributes setValue:[NSNumber numberWithInteger:kCTUnderlineStyleSingle] forKey:(NSString*)kCTUnderlineStyleAttributeName];
    
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] autorelease];
}


+ (NSAttributedString*)myString
{
    // Creating fonts, color and URL that will be used in this exemple
    UIFont *normalFont = [UIFont fontWithName:@"AmericanTypewriter" size:16];
    UIFont *boldFont = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:16];
    UIFont *bigFont = [UIFont fontWithName:@"AmericanTypewriter" size:32];
    
    UIColor *normalColor = [UIColor colorWithRed:0 green:0.5 blue:0 alpha:1]; // normal text color will be green
    
    NSURL *url = [NSURL URLWithString:@"http://www.bbc.co.uk/doctorwho/dw"];
    
    
    // Creating a Mutable attributedString
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    // Creating first part of the text with no link, normal font and normal color.
    [attributedString appendAttributedString:[NSAttributedString attributedStringWithString:@"Look at the sky. It's not "
                                                                                       font:normalFont
                                                                                      color:normalColor
                                                                                       link:nil
                                                                                 underlined:NO]];
    
    // Creating second part of the text with no link, bold font and grey color.
    [attributedString appendAttributedString:[NSAttributedString attributedStringWithString:@"dark"
                                                                                       font:boldFont
                                                                                      color:[UIColor colorWithWhite:0.314 alpha:1]
                                                                                       link:nil
                                                                                 underlined:NO]];
    
    // Creating third part of the text with no link, normal font and normal color.
    [attributedString appendAttributedString:[NSAttributedString attributedStringWithString:@" or "
                                                                                       font:normalFont
                                                                                      color:normalColor
                                                                                       link:nil
                                                                                 underlined:NO]];
    
    // Creating fourth part of the text with no link, bold font and black color.
    [attributedString appendAttributedString:[NSAttributedString attributedStringWithString:@"black"
                                                                                       font:boldFont
                                                                                      color:[UIColor blackColor]
                                                                                       link:nil
                                                                                 underlined:NO]];
    
    // Creating fifth part of the text with no link, normal font and normal color.
    [attributedString appendAttributedString:[NSAttributedString attributedStringWithString:@" and without character. The "
                                                                                       font:normalFont
                                                                                      color:normalColor
                                                                                       link:nil
                                                                                 underlined:NO]];
    
    // Creating sixth part of the text with no link, bold font and black color.
    [attributedString appendAttributedString:[NSAttributedString attributedStringWithString:@"black"
                                                                                       font:boldFont
                                                                                      color:[UIColor blackColor]
                                                                                       link:nil
                                                                                 underlined:NO]];
    
    // Creating seventh part of the text with no link, normal font and normal color.
    [attributedString appendAttributedString:[NSAttributedString attributedStringWithString:@" is in fact\n"
                                                                                       font:normalFont
                                                                                      color:normalColor
                                                                                       link:nil
                                                                                 underlined:NO]];
    
    // Creating heighth part of the text with link, big font and blue color.
    [attributedString appendAttributedString:[NSAttributedString attributedStringWithString:@"deep blue"
                                                                                       font:bigFont
                                                                                      color:[UIColor blueColor]
                                                                                       link:url
                                                                                 underlined:YES]];
    
    return [attributedString autorelease];
}


@end
