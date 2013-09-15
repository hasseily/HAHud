//
//  HAHud.m
//  HAHudDemo
//
//  Created by Henri Asseily on 9/12/13.
//  Copyright (c) 2013 Henri Asseily. All rights reserved.
//

#import "HAHud.h"
//#import <QuartzCore/QuartzCore.h>

#define HAHUDVIEWTAG 666666



@interface HABlockView : UIView
- (void)dismiss;
@property (nonatomic, copy) void (^completionBlock)(NSUInteger selectedButtonIndex);
@end


@implementation HABlockView

// We create a subclass of UIView to hold the completion block
// because it is not guaranteed that the HAHud object is still alive
// when the completion happens. On the other hand, the view is certainly
// happily on screen.

- (void)dismiss {
    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (void)didTapButton:(UIButton *)sender {
    [self dismiss];
    if (self.completionBlock) {
        self.completionBlock(sender.tag);
    }
}

@end

@interface HAHud (PrivateMethods)

+ (instancetype)hudAllocator;
- (void)initView;
- (void)addActivityIndicator;
- (void)addBooleanMark:(BOOL)mark;
- (void)addProgressView:(CGFloat)progress;
- (void)addButtonTitles:(NSArray *)buttonTitles stacked:(BOOL)stacked;
- (void)didTapButton:(UIButton *)sender;
+ (UIWindow *)win;
+ (UIButton *)roundedButton;

@end

@implementation HAHud

HABlockView *_view;         // transparent full-screen view
UIView *_accView;           // buttons view wrapper

# pragma mark constructors

+ (instancetype)hudAllocator {
    HAHud *hud = nil;
    if ((hud = [[[HAHud alloc] init] autorelease])) {
        [hud initView];
    }
    return hud;
}

+ (instancetype)hud {
    HAHud *hud = [self hudAllocator];
    // Center the message in the hud, as there's nothing else
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:hud.message
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:hud->_hudView
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.f constant:0.f]];
    [hud->_hudView addConstraints:constraints];
    return hud;
}

+ (instancetype)hudWithActivityIndicator {
    HAHud *hud = [self hudAllocator];
    if (hud) {
        [hud addActivityIndicator];
    }
    return hud;
}

+ (instancetype)hudWithBooleanMark:(BOOL)mark {
    HAHud *hud = [self hudAllocator];
    if (hud) {
        [hud addBooleanMark:mark];
    }
    return hud;
}

+ (instancetype)hudWithProgressRate:(CGFloat)progress {
    HAHud *hud = [self hudAllocator];
    if (hud) {
        [hud addProgressView:progress];
    }
    return hud;
}

+ (instancetype)hudWithButtonTitles:(NSArray *)buttonTitles stacked:(BOOL)stacked {
    HAHud *hud = [self hudAllocator];
    if (hud) {
        [hud addButtonTitles:buttonTitles stacked:stacked];
    }
    return hud;
}

#pragma mark destructor

- (void)dealloc {
    NSLog(@"dealloc");
    [_view release];
    _view = nil;
    [super dealloc];
}

#pragma mark class methods

+ (BOOL)isHudDisplayedInView:(UIView *)parentView {
    if (!parentView) {
        parentView = [self win];
    }
    NSArray *subs = parentView.subviews;
    for (UIView *aView in subs) {
        if (aView.tag == HAHUDVIEWTAG) {
            return YES;
        }
    }
    return NO;
}

+ (UIWindow *)win {
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    return window;
}

+ (UIButton *)roundedButton {
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [aButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [aButton setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateHighlighted];
    aButton.titleLabel.backgroundColor = [UIColor clearColor];
    aButton.titleLabel.numberOfLines = 1;
    aButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    aButton.layer.cornerRadius = 2;
    aButton.layer.borderWidth = 1;
    aButton.layer.borderColor = [UIColor whiteColor].CGColor;
    aButton.clipsToBounds = YES;
    aButton.titleLabel.font = [UIFont systemFontOfSize: 12];
    return aButton;
}

#pragma mark view methods

- (void)initView {
    if (_view) {
        return;
    }
    _view = [[HABlockView alloc] initWithFrame:[[self class] win].bounds];
    _view.backgroundColor = [UIColor clearColor];
    _view.translatesAutoresizingMaskIntoConstraints = NO;
    _hudView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    _hudView.backgroundColor = [UIColor blackColor];
    _hudView.alpha = 0.8;
    _hudView.layer.cornerRadius = 2;
    _hudView.translatesAutoresizingMaskIntoConstraints = NO;
    [_view addSubview:_hudView];
    
    NSMutableArray *constraints = [NSMutableArray array];
    // These constraints determine the minimum size of the hud view and the padding
    [constraints addObjectsFromArray:[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"|-(>=20)-[item(>=170)]-(>=20)-|"
                                      options:NSLayoutFormatAlignAllCenterX
                                      metrics:nil
                                      views:@{@"item": _hudView}]];
    [constraints addObjectsFromArray:[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"V:|-(>=50)-[item(>=100)]-(>=50)-|"
                                      options:NSLayoutFormatAlignAllCenterX
                                      metrics:nil
                                      views:@{@"item": _hudView}]];
    
    // These constraints center the hud view in both axes X & Y
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_hudView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_hudView.superview
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.f constant:0.f]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_hudView
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_hudView.superview
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.f constant:0.f]];
    [_view addConstraints:constraints];

    // Add the text label first
    [constraints removeAllObjects];
    _message = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    _message.text = @"";
    _message.numberOfLines = 0;
    _message.textAlignment = NSTextAlignmentCenter;
    _message.backgroundColor = [UIColor clearColor];
    _message.textColor = [UIColor whiteColor];
    _message.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    _message.translatesAutoresizingMaskIntoConstraints = NO;
    [_hudView addSubview:_message];

    [constraints addObjectsFromArray:[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"|-20-[label]-20-|"
                                      options:NSLayoutFormatAlignAllCenterX
                                      metrics:nil
                                      views:@{@"label": _message}]];
    [constraints addObjectsFromArray:[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"V:|-20-[label]"
                                      options:NSLayoutFormatAlignAllCenterX
                                      metrics:nil
                                      views:@{@"label": _message}]];
    [_hudView addConstraints:constraints];

}

- (void)addActivityIndicator {
    if (self.activityIndicator) {
        [self.activityIndicator removeFromSuperview];
        self.activityIndicator = nil;
    }
    self.activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
    [self.activityIndicator startAnimating];
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [_hudView addSubview:self.activityIndicator];
    
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObjectsFromArray:[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"|-(>=20)-[item]-(>=20)-|"
                                      options:NSLayoutFormatAlignAllCenterY
                                      metrics:nil
                                      views:@{@"item": _activityIndicator}]];
    [constraints addObjectsFromArray:[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"V:[label]-(>=20)-[item]-20-|"
                                      options:NSLayoutFormatAlignAllCenterX
                                      metrics:nil
                                      views:@{@"label": _message, @"item": _activityIndicator}]];
    
    // Center on X
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_activityIndicator
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_activityIndicator.superview
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.f constant:0.f]];
    [_hudView addConstraints:constraints];
}

- (void)addBooleanMark:(BOOL)mark {
    if (self.booleanMarkView) {
        [self.booleanMarkView removeFromSuperview];
        self.booleanMarkView = nil;
    }
    UIImage *markImage;
    markImage = mark ? [UIImage imageNamed:@"hud-1"] : [UIImage imageNamed:@"hud-0"];
    self.booleanMarkView = [[[UIImageView alloc] initWithImage:markImage] autorelease];
    self.booleanMarkView.translatesAutoresizingMaskIntoConstraints = NO;
    [_hudView addSubview:self.booleanMarkView];
    
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObjectsFromArray:[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"|-(>=20)-[item]-(>=20)-|"
                                      options:NSLayoutFormatAlignAllCenterY
                                      metrics:nil
                                      views:@{@"item": _booleanMarkView}]];
    [constraints addObjectsFromArray:[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"V:[label]-(>=20)-[item]-20-|"
                                      options:NSLayoutFormatAlignAllCenterX
                                      metrics:nil
                                      views:@{@"label": _message, @"item": _booleanMarkView}]];
    
    // Center on X
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_booleanMarkView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_booleanMarkView.superview
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.f constant:0.f]];
    [_hudView addConstraints:constraints];
}

- (void)addProgressView:(CGFloat)progress {
    if (self.progressView) {
        [self.progressView removeFromSuperview];
        self.progressView = nil;
    }
    self.progressView = [[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault] autorelease];
    self.progressView.progress = progress;
    self.progressView.backgroundColor = [UIColor greenColor];
    self.progressView.progressTintColor = [UIColor whiteColor];
    self.progressView.trackTintColor = [UIColor darkGrayColor];
    self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
    [_hudView addSubview:self.progressView];

    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObjectsFromArray:[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"|-20-[item]-20-|"
                                      options:NSLayoutFormatAlignAllCenterY
                                      metrics:nil
                                      views:@{@"item": _progressView}]];
    [constraints addObjectsFromArray:[NSLayoutConstraint
                                      constraintsWithVisualFormat:@"V:[label]-(>=20)-[item]-20-|"
                                      options:NSLayoutFormatAlignAllCenterX
                                      metrics:nil
                                      views:@{@"label": _message, @"item": _progressView}]];
    
    // Center on X
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_progressView
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_progressView.superview
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.f constant:0.f]];
    [_hudView addConstraints:constraints];
}

- (void)addButtonTitles:(NSArray *)buttonTitles stacked:(BOOL)stacked {
    if (self.buttons) {
        for (UIButton *button in self.buttons) {
            [button removeFromSuperview];
        }
        self.buttons = nil;
        [_accView release];
    }
    if (buttonTitles.count == 0) {
        return;
    }

    // now generate the constraints with a visual format
    NSMutableArray *wrapperConstraints = [NSMutableArray array];
    
    // Add a wrapper view that will wrap the buttons
    // It'll also be centered on X
    // It is needed especially for buttons side by side
    _accView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    _accView.backgroundColor = [UIColor clearColor];
    _accView.translatesAutoresizingMaskIntoConstraints = NO;
    [_hudView addSubview:_accView];

    [wrapperConstraints addObjectsFromArray:[NSLayoutConstraint
                                             constraintsWithVisualFormat:@"V:[label]-20-[acc(>=20)]-10-|"
                                             options:NSLayoutFormatAlignAllCenterX
                                             metrics:nil
                                             views:@{@"label": _message, @"acc": _accView}]];
    [wrapperConstraints addObjectsFromArray:[NSLayoutConstraint
                                             constraintsWithVisualFormat:@"|-10-[acc]-10-|"
                                             options:NSLayoutFormatAlignAllCenterY
                                             metrics:nil
                                             views:@{@"acc": _accView}]];
    [_hudView addConstraints:wrapperConstraints];

    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSUInteger i=0; i<buttonTitles.count; i++) {
        UIButton *b = [[self class] roundedButton];
        [b setTitle:[buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
        b.translatesAutoresizingMaskIntoConstraints = NO;
        b.tag = i;
        [b addTarget:_view action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [_accView addSubview:b];
        [tempArray addObject:b];
    }
    self.buttons = tempArray;

    NSMutableArray *constraints = [NSMutableArray array];

    if (stacked) {
        // When stacked, it's easy. Each button is the width of the hud minus the padding
        // and each button is aligned below the previous one, where the last is just above the bottom

        NSMutableString *dynamicConstraint = [NSMutableString stringWithString:@"V:|"];
        NSString *itemS;
        NSMutableDictionary *viewsDict = [NSMutableDictionary dictionary];
        
        for (NSUInteger i=0; i<self.buttons.count; i++) {
            // horizontal constraint to span the whole wrapper view
            [constraints addObjectsFromArray:[NSLayoutConstraint
                                              constraintsWithVisualFormat:@"|[item(==wrapper)]|"
                                              options:NSLayoutFormatAlignAllCenterY
                                              metrics:nil
                                              views:@{@"item": [_buttons objectAtIndex:i], @"wrapper": _accView}]];
            // add to vertical constraint
            itemS = [NSString stringWithFormat:@"item_%lu", (unsigned long)i];
            if (i == 0) {
                [dynamicConstraint appendFormat:@"[%@]", itemS];

            } else {
                [dynamicConstraint appendFormat:@"-10-[%@]", itemS];
            }
            [viewsDict setObject:[_buttons objectAtIndex:i] forKey:itemS];
        }
        [dynamicConstraint appendString:@"|"];  // finish by aligning to bottom
        [constraints addObjectsFromArray:[NSLayoutConstraint
                                          constraintsWithVisualFormat:dynamicConstraint
                                          options:NSLayoutFormatAlignAllCenterX
                                          metrics:nil
                                          views:viewsDict]];
    } else {
        // When side by side, all the buttons align horizontally inside the wrapper view
        // and they all use the same width which is at most the size of the wrapper
        
        NSMutableString *dynamicConstraint = [NSMutableString stringWithString:@"H:|"];
        NSString *itemS;        // tag of the current button
        NSString *firstItemS;   // tag of the first button
        NSMutableDictionary *viewsDict = [NSMutableDictionary dictionaryWithObject:_accView forKey:@"wrapper"];
        
        for (NSUInteger i=0; i<self.buttons.count; i++) {
            // simple vertical constraint
            [constraints addObjectsFromArray:[NSLayoutConstraint
                                              constraintsWithVisualFormat:@"V:|[item]|"
                                              options:NSLayoutFormatAlignAllCenterX
                                              metrics:nil
                                              views:@{@"item": [_buttons objectAtIndex:i], @"wrapper": _accView}]];
            // add to horizontal constraint
            itemS = [NSString stringWithFormat:@"item_%lu", (unsigned long)i];
            if (i==0) {
                firstItemS = itemS;
                [dynamicConstraint appendFormat:@"[%@(<=wrapper)]", itemS];
            } else {
                [dynamicConstraint appendFormat:@"-10-[%@(==%@)]", itemS, firstItemS];
            }
            [viewsDict setObject:[_buttons objectAtIndex:i] forKey:itemS];
        }
        [dynamicConstraint appendString:@"|"];  // finish by aligning to right
        [constraints addObjectsFromArray:[NSLayoutConstraint
                                          constraintsWithVisualFormat:dynamicConstraint
                                          options:NSLayoutFormatAlignAllCenterY
                                          metrics:nil
                                          views:viewsDict]];
    }
    
    [_accView addConstraints:constraints];
}

- (void)setCompletion:(void (^)(NSUInteger))completionBlock {
    _view.completionBlock = completionBlock;
}

- (void)show {
    if (self.parentView) {
        _view.frame = self.parentView.bounds;
        [self.parentView addSubview:_view];
    } else {
        [[[self class] win] addSubview:_view];
    }
    // Center the _view inside the parentView, so that autorotation is properly handled
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_view
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_view.superview
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.f constant:0.f]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_view
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:_view.superview
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.f constant:0.f]];
    [_view.superview addConstraints:constraints];
}

- (void)dismiss {
    [_view dismiss];
}

- (void)dismissAfterInterval:(NSTimeInterval)interval {
    [_view performSelector:@selector(dismiss) withObject:nil afterDelay:interval];
}

@end
