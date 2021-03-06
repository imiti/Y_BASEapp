//
//  JGProgressHUDRingIndicatorView.h
//  JGProgressHUD
//
//  Created by Jonas Gessner on 20.7.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//  

#import "JGProgressHUD.h"
#import "JGProgressHUDIndicatorView.h"

@interface JGProgressHUDRingIndicatorView : JGProgressHUDIndicatorView

/**
 Initializes the indicator view and sets the correct color to match the HUD style.
 */
- (instancetype)initWithHUDStyle:(JGProgressHUDStyle)style;

/**
 Background color of the ring.
 
@b Default: black.
 */
@property (nonatomic, strong) UIColor *ringBackgroundColor;

/**
 Progress color of the progress ring.
 
@b Default: white.
 */
@property (nonatomic, strong) UIColor *ringColor;

/**
 Sets if the progress ring should have rounded corners.
 
@b Default: NO.
 */
@property (nonatomic, assign) BOOL roundProgressLine;

/**
 Width of the ring.
 
@b Default: 5.0
 */
@property (nonatomic, assign) CGFloat ringWidth;

@end
