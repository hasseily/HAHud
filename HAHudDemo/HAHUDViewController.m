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
    NSString *msg = @"Thanks for using this code chunk.\nI hope you find it useful.\nhttp://henri.tel";
    HAHud *hud;
    switch (sender.tag) {
        case 11:
            hud = [HAHud hud];
            [hud hideAfterInterval:3];
            break;
        case 12:
            hud = [HAHud hudWithActivityIndicator];
            [hud hideAfterInterval:3];
            break;
        case 13:
            hud = [HAHud hudWithProgressRate:0.3f];
            hud.progressView.progress = 0.7f;
            [hud hideAfterInterval:3];
            break;
        case 14:
            hud = [HAHud hudWithBooleanMark:YES];
            [hud hideAfterInterval:3];
            break;
        case 15:
            hud = [HAHud hudWithButtonTitles:@[@"Cancel", @"OK"] stacked:NO];
            [hud setCompletion:^(NSUInteger bTag) {
                HAHud *newHud = [HAHud hud];
                newHud.message.text = [NSString stringWithFormat:@"You tapped button # %lu", (unsigned long)bTag];
                [newHud show];
                [newHud hideAfterInterval:2];
            }];
            break;
        case 16:
            hud = [HAHud hudWithButtonTitles:@[@"Tap me", @"Click me", @"Touch me please"] stacked:YES];
            break;
        default:
            hud = [HAHud hud];
            [hud hideAfterInterval:3];
            break;
    }
    hud.message.text = msg;
    [hud show];
}


@end
