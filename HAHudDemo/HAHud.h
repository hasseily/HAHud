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
        - message: the message UILabel
        - dismissalBlock : triggers on a button tap (hud is automatically dismissed)
        - activityIndicator: it is automatically on as the view is shown
        - progressView: set progress directly on it
*/

#import <UIKit/UIKit.h>
@class HABlockView;

@interface HAHud : NSObject

+ (instancetype)hud;
+ (instancetype)hudWithActivityIndicator;
+ (instancetype)hudWithBooleanMark:(BOOL)mark;
+ (instancetype)hudWithProgressRate:(CGFloat)progress;
+ (instancetype)hudWithButtonTitles:(NSArray *)buttonTitles stacked:(BOOL)stacked;

+ (BOOL)hudIsDisplayed;     // is a hud already displayed on screen?

- (void)show;   // Returns NO if won't display because another is already showing
- (void)hide;
- (void)hideAfterInterval:(NSTimeInterval)interval;
- (void)setCompletion:(void (^)(NSUInteger selectedButtonIndex))completionBlock;

@property (nonatomic, retain) UILabel *message;     // message to display
@property (nonatomic, readonly) HABlockView *view;         // transparent full-screen view
@property (nonatomic, readonly) UIView *hudView;      // the actual hud view
@property (nonatomic, readonly) UIView *accView;    // accessories (buttons, activity...) view
@property (nonatomic, retain) UIImageView *booleanMarkView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UIProgressView *progressView;
@property (nonatomic, retain) NSArray *buttons;

@end
