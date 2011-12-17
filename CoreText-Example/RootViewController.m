//
//  RootViewController.m
//  CoreText-Example
//
//  Created by Thibaut Jarosz on 08/09/11.
//  Copyright 2011 Octiplex. All rights reserved.
//

#import "RootViewController.h"
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
#import "NSAttributedString+MyString.h"
#import "CoreTextView.h"


#pragma mark - Private interface

@interface RootViewController ()
- (void)fillCoreAnimationViewWithText:(NSAttributedString*)text; // Update the CoreAnimation view
- (void)fillCoreTextViewWithText:(NSAttributedString*)text; // Update the CoreText view
@end


#pragma mark -

@implementation RootViewController

@synthesize coreAnimationContainerTextView=_coreAnimationContainerTextView;
@synthesize coreTextContainerView=_coreTextContainerView;


#pragma mark - Init & Dealloc

- (void)dealloc
{
    [_coreAnimationContainerTextView release];
    [_coreTextContainerView release];
    [_coreAnimationTextLayer release];
    [_coreTextView release];
    
    [super dealloc];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Set rounded corners
    self.coreAnimationContainerTextView.layer.cornerRadius = self.coreTextContainerView.layer.cornerRadius = 10;
    
    // Creating NSAttributedString (see MyString category for more information)
    NSAttributedString *myString = [NSAttributedString myString];
    
    // Update views using attributed string
    [self fillCoreAnimationViewWithText:myString];
    [self fillCoreTextViewWithText:myString];
}


#pragma mark - Core Animation

- (void)fillCoreAnimationViewWithText:(NSAttributedString*)text
{
    if (!_coreAnimationTextLayer) {
        // If no _coreAnimationTextLayer, creating a CATextLayer and adding it to the top view
        _coreAnimationTextLayer = [[CATextLayer alloc] init];
        _coreAnimationTextLayer.frame = CGRectMake(10, 10, self.coreAnimationContainerTextView.bounds.size.width-20, self.coreAnimationContainerTextView.bounds.size.height-20);
        
        // Text must go to new line at the end of the frame
        _coreAnimationTextLayer.wrapped = YES;
        
        // adding CATextLayer into the existing CALayer
        [self.coreAnimationContainerTextView.layer addSublayer:_coreAnimationTextLayer];
    }
    
    // updating displayed text
    _coreAnimationTextLayer.string = text;
}


#pragma mark - Core Text

- (void)fillCoreTextViewWithText:(NSAttributedString*)text
{
    if (!_coreTextView) {
        // If no _coreTextView, creating a CoreTextView and adding it to the bottom view
        _coreTextView = [[CoreTextView alloc] initWithFrame:CGRectMake(10, 10, self.coreTextContainerView.bounds.size.width-20, self.coreTextContainerView.bounds.size.height-20)];
        
        // Ajout du CoreTextView dans la vue existante
        [self.coreTextContainerView addSubview:_coreTextView];
    }
    
    // updating displayed text (see CoreTextView class for more information)
    _coreTextView.attributedString = text;
}

@end
