//
//  CoreTextView.m
//  CoreText-Example
//
//  Created by Thibaut Jarosz on 08/09/11.
//  Copyright 2011 Octiplex. All rights reserved.
//

#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

#import "CoreTextView.h"


const CFStringRef kCoreTextViewLinkAttributeName = (CFStringRef)@"kCoreTextViewLinkAttributeValue";


@implementation CoreTextView

@synthesize attributedString=_attributedString;


#pragma mark - Init & Dealloc
- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame]))
    {
        self.backgroundColor = [UIColor clearColor];
        // Adding UITapGestureRecognizer
		UITapGestureRecognizer* tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(receivedTap:)] autorelease];
		[self addGestureRecognizer:tap];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // Adding UITapGestureRecognizer
		UITapGestureRecognizer* tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(receivedTap:)] autorelease];
		[self addGestureRecognizer:tap];
    }
    return self;
}

- (void)dealloc
{
    if (_textFrame)
        CFRelease(_textFrame); // Remember: CFRelease parameter cannot be NULL
	[_attributedString release];
	[super dealloc];
}


#pragma mark - Text drawing
- (void)drawRect:(CGRect)rect
{
    // Getting current context
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect bounds = self.bounds;
    
    // Setting background
    if (self.backgroundColor) {
        CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
        CGContextFillRect(context, bounds);
    }
    
    // Releasing old text frame
    if (_textFrame) {
        CFRelease(_textFrame); // Remember: CFRelease parameter cannot be NULL
        _textFrame = NULL;
    }
    
    
    // TextFramesetter: used to calculate a CTFrame from the attributedString it contains
    CTFramesetterRef textFramesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef) (_attributedString ? : [[NSAttributedString new] autorelease]));
    
    // Path: contains the rectangle where the text will be drawn
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, bounds);
    
    // Generating the CTFrame, used to draw the text
    CFRange range = CFRangeMake(0, _attributedString.length);
    _textFrame = CTFramesetterCreateFrame(textFramesetter, range, path, NULL);
    CGPathRelease(path);
    
    
    // Inverting display of the context (comments the 2 lines if you want to know why)
    CGAffineTransform transform = CGAffineTransformMake(1, 0, 0, -1, 0, bounds.size.height);
    CGContextConcatCTM(context, transform);
    
    
    // Draw the text
    CTFrameDraw(_textFrame, context);
}


#pragma mark - Touch handling
- (void)receivedTap:(UITapGestureRecognizer*)recognizer
{
    // Getting touch point, transformed to match the CTFrame
    CGAffineTransform transform = CGAffineTransformMake(1, 0, 0, -1, 0, self.bounds.size.height);
    CGPoint point = CGPointApplyAffineTransform([recognizer locationInView:self], transform);
    
    // A CTFrame contains multiple CTLine, representing line of text (4 in this application exemple).
    // Each CTLine contains multiple CTRun, representing multiple following characters with the same attributes.
    // In this exemple, the first CTLine contains 3 CTRun, the second and the third contain 2 CTRun, and the last CTLine has only one CTRun.
    
    // To open a link, we search for the CTLine that has been touch, then the CTRun inside this CTLine and if the CTRun has a link, we open it.
    
    
    // Getting all CTLine
    CFArrayRef lines = CTFrameGetLines(_textFrame);
    CFIndex countOfLines = CFArrayGetCount(lines);
    
    for ( CFIndex i = 0; i < countOfLines; i++ ) // For each CTLine
    {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGRect lineRect = CGRectZero;;
        CGFloat ascent = 0, descent = 0;
        
        // Calculating CTLine frame 
        CTFrameGetLineOrigins(_textFrame, CFRangeMake(i, 1), &lineRect.origin);
        lineRect.size.width = CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
        lineRect.size.width -= CTLineGetTrailingWhitespaceWidth(line);
        lineRect.size.height = ascent + descent;
        lineRect.origin.y -= descent;
        lineRect = CGRectIntegral(lineRect);
        
        if ( ! CGRectContainsPoint(lineRect, point) )
            continue; // If CTLine does not contains point, going to next CTLine
        
        
        // Getting all CTRun of the CTLine
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        CFIndex countOfRuns = CFArrayGetCount(runs);
        
        for ( CFIndex j = 0; j < countOfRuns; j++ ) // For each CTRun in CTLine
        {
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            
            // Calculating CTRun frame 
            CGRect runRect = CGRectZero;
            CTFrameGetLineOrigins(_textFrame, CFRangeMake(i, 1), &runRect.origin);
            CGFloat runAscent, runDescent;
            runRect.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &runAscent, &runDescent, NULL);
            runRect.size.height = runAscent + runDescent;
            runRect.origin.x = lineRect.origin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            runRect.origin.y = lineRect.origin.y - runDescent;
            runRect = CGRectIntegral(runRect);
            
            if ( ! CGRectContainsPoint(runRect, point) )
                continue; // If CTRun does not contains point, going to next CTRun
            
            // The current CTRun is the touched CTRun
            
            // Getting the attributes of the CTRun 
            NSDictionary* attributes = (NSDictionary*)CTRunGetAttributes(run);
            
            // Getting the URL
            NSURL* url = [attributes objectForKey:(NSString*)kCoreTextViewLinkAttributeName];
            if(url) // If there is an URL, opening it in Safari
                [[UIApplication sharedApplication] openURL:url];
            
            return;
        }
    }
}


#pragma mark - setters
- (void)setAttributedString:(NSAttributedString *)attributedString
{
    if (attributedString!=_attributedString) {
        [_attributedString release];
        _attributedString = [attributedString retain];
        [self setNeedsDisplay]; // asking to update the interface
    }
}

@end
