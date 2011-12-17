//
//  RootViewController.h
//  CoreText-Example
//
//  Created by Thibaut Jarosz on 08/09/11.
//  Copyright 2011 Octiplex. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CATextLayer;
@class CoreTextView;


/********************************************************************************************************
 *  RootViewController:                                                                                 *
 *  Display a NSAttributedString using two ways : CoreAnimation and CoreText                            *
 *                                                                                                      *
 *  CoreAnimation                                                                                       *
 *      Plus : easy to use                                                                              *
 *      Minus :                                                                                         *
 *          - Uses more memory and slower than CoreText (should not be used in a TableView)             *
 *          - Does not implement link on some part of a text                                            *
 *                                                                                                      *
 *  CoreText                                                                                            *
 *      Plus :                                                                                          *
 *          - Faster than CoreAnimation                                                                 *
 *          - Allow to "easily" add links on text (should be manually implemented)                      *
 *      Minus : Needs some knowledge in CoreGraphics                                                    *
 *                                                                                                      *
 ********************************************************************************************************/


@interface RootViewController : UIViewController
{
    UIView *_coreAnimationContainerTextView; // top container view (with rounded corners)
    UIView *_coreTextContainerView; // bottom container view (with rounded corners)
    
    CATextLayer *_coreAnimationTextLayer; // CoreAnimation layer, used in top view to display a NSAttributedString
    CoreTextView *_coreTextView; // CoreTextView, a custom view vue that implement CoreText display of a NSAttributedString
}

@property (nonatomic, retain) IBOutlet UIView *coreAnimationContainerTextView;
@property (nonatomic, retain) IBOutlet UIView *coreTextContainerView;

@end
