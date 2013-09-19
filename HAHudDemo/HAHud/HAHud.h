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
 
 Use setCompletion: to assign a callback which will trigger when the hud is dismissed.
 If a button was pressed, then the button index is passed in, otherwise 0.
 
 Use isHudDisplayedInView: to check if there's a hud showing on parentView.
 If you pass in nil, then the window is checked.
 
 NOTE:   if the parentView is the default window, then the hud won't properly autorotate.
 Use your view controller's main view whenever you can.
 */

#import <UIKit/UIKit.h>

@interface HAHud : NSObject

// Create an alert with just a message.
+ (instancetype)hud;
// Create an alert with a message and running activity indicator
+ (instancetype)hudWithActivityIndicator;
// Create an alert with a message and a boolean mark ("x" or "✔")
+ (instancetype)hudWithBooleanMark:(BOOL)mark;
// Create an alert with a message and a progress indicator
+ (instancetype)hudWithProgressRate:(CGFloat)progress;
// Create an alert with a message and buttons, stacked or not
+ (instancetype)hudWithButtonTitles:(NSArray *)buttonTitles stacked:(BOOL)stacked;
// Create an alert with a message, a boolean mark, and buttons side by side
+ (instancetype)hudWithButtonTitles:(NSArray *)buttonTitles booleanMark:(BOOL)mark;

// is a hud already displayed on screen?
+ (BOOL)isHudDisplayedInView:(UIView *)parentView;

// Show the hud
- (void)show;                           // shows in window or self.parentView
- (void)showInView:(UIView *)view;      // shortcut to set parentView and show
                                        // Dismiss the hud
- (void)dismiss;
// Dismiss the hud after interval seconds
- (void)dismissAfterInterval:(NSTimeInterval)interval;
// Set the completion block that will trigger on any button press
// The hud is automatically dismissed before the completion block is triggered
- (void)setCompletion:(void (^)(NSUInteger selectedButtonIndex))completionBlock;

@property (nonatomic) CGFloat buttonHeight;                                 // Height of the buttons (defaults to 40)
@property (nonatomic, assign) UIView *parentView;                           // view to attach the hud to (defaults to window)
@property (nonatomic, retain) UILabel *message;                             // message to display
@property (nonatomic, readonly) UIView *hudView;                            // the actual hud view
@property (nonatomic, retain) UIImageView *booleanMarkView;                 // the boolean mark view
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;   // the activity indicator view
@property (nonatomic, retain) UIProgressView *progressView;                 // the progress view
@property (nonatomic, retain) NSArray *buttons;                             // the buttons array. They are instances of a UIButton subclass

@end
