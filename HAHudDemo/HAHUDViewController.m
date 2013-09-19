//
//  HAHUDViewController.m
//  HAHudDemo
//
//  Created by Henri Asseily on 9/12/13.
//  Copyright (c) 2013 Henri Asseily. All rights reserved.
//

#import "HAHUDViewController.h"
#import "HAHud.h"

@interface HAHUDViewController ()

@end

@implementation HAHUDViewController

- (IBAction)didTouchButton:(UIButton *)sender {
    NSString *msg = @"This is a demo of HAHud where the messages can be very long. Be careful with the screen size!\n\nThanks for trying it out.";
    HAHud *hud;
    switch (sender.tag) {
        case 11:
            hud = [HAHud hud];
            [hud dismissAfterInterval:3];
            break;
        case 12:
            hud = [HAHud hudWithActivityIndicator];
            [hud dismissAfterInterval:3];
            break;
        case 13:
            hud = [HAHud hudWithProgressRate:0.3f];
            hud.progressView.progress = 0.7f;
            [hud dismissAfterInterval:3];
            break;
        case 14:
            hud = [HAHud hudWithBooleanMark:YES];
            [hud dismissAfterInterval:3];
            break;
        case 15:
            hud = [HAHud hudWithButtonTitles:@[@"Cancel", @"OK"] stacked:NO];
            [hud setCompletion:^(NSUInteger bTag) {
                HAHud *newHud = [HAHud hudWithButtonTitles:@[@"OK"] booleanMark:bTag];
                newHud.message.text = [NSString stringWithFormat:@"You tapped button # %lu", (unsigned long)bTag];
                newHud.parentView = self.view;
                [newHud show];
            }];
            break;
        case 16:
            hud = [HAHud hudWithButtonTitles:@[@"Tap me", @"Click me", @"Touch me please"] stacked:YES];
            break;
        default:
            hud = [HAHud hud];
            [hud dismissAfterInterval:3];
            break;
    }
    hud.message.text = msg;
    hud.parentView = self.view;
    [hud show];
}


@end
