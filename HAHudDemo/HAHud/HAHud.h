//
//  HAHud.h
//
//  Created by Henri Asseily on 9/12/13.
//  Copyright (c) 2013 Henri Asseily. All rights reserved.
//
/*
 @abstract:
    Provides a configurable alert hud with multiple display options
    The hud will have a message and optionally any of:
        - An activity indicator
        - A check or "x"
        - A progress indicator
        - Buttons side by side or stacked vertically
 
    Important properties are:
        - parentView: the view on which the hud will display (defaults to the window)
        - message: the message UILabel
        - activityIndicator: it is automatically on as the view is shown
        - progressView: set progress directly on it
    
    Use setCompletion: to assign a callback which will trigger when a button is pressed
    
    Use isHudDisplayedInView: to check if there's a hud showing on parentView.
    If you pass in nil, then the window is checked.
 
    NOTE:   if the parentView is the default window, then the hud won't properly autorotate.
            Use your view controller's main view whenever you can.
*/

#import <UIKit/UIKit.h>

@interface HAHud : NSObject

+ (instancetype)hud;
+ (instancetype)hudWithActivityIndicator;
+ (instancetype)hudWithBooleanMark:(BOOL)mark;
+ (instancetype)hudWithProgressRate:(CGFloat)progress;
+ (instancetype)hudWithButtonTitles:(NSArray *)buttonTitles stacked:(BOOL)stacked;
+ (instancetype)hudWithButtonTitles:(NSArray *)buttonTitles booleanMark:(BOOL)mark;

+ (BOOL)isHudDisplayedInView:(UIView *)parentView;     // is a hud already displayed on screen?

- (void)show;
- (void)dismiss;
- (void)dismissAfterInterval:(NSTimeInterval)interval;
- (void)setCompletion:(void (^)(NSUInteger selectedButtonIndex))completionBlock;

@property (nonatomic) CGFloat buttonHeight;             // Height of the buttons (defaults to 40)
@property (nonatomic, assign) UIView *parentView;       // view to attach the hud to (defaults to window)
@property (nonatomic, retain) UILabel *message;         // message to display
@property (nonatomic, readonly) UIView *hudView;        // the actual hud view
@property (nonatomic, retain) UIImageView *booleanMarkView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UIProgressView *progressView;
@property (nonatomic, retain) NSArray *buttons;

@end