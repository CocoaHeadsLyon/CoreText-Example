//
//  CoreTextView.h
//  CoreText-Example
//
//  Created by Thibaut Jarosz on 08/09/11.
//  Copyright 2011 Octiplex. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CFStringRef kCoreTextViewLinkAttributeName;


/********************************************************************************************************
 *  CoreTextView:                                                                                       *
 *                                                                                                      *
 *  Updating CoreText display is managed in drawRect:                                                   *
 *  Each time the attributedString property changes, drawRect: is indirectly called                     *
 *                                                                                                      *
 *  To add links on a part of the text, add a NSURL value to the                                        *
 *      kCoreTextViewLinkAttributeName attribute key                                                    *
 *                                                                                                      *
 *  Tap on links are detected using a UITapGestureRecognizer.                                           *
 *  A tap on the view will calculate the tapped text and open the associated URL (if it exists).        *
 *                                                                                                      *
 ********************************************************************************************************/

@interface CoreTextView : UIView
{
    NSAttributedString* _attributedString; // currently displayed attributedString
	CTFrameRef _textFrame; // CoreText frame, reference is used detect touch on a link
}

@property (nonatomic, retain) NSAttributedString* attributedString;

@end
