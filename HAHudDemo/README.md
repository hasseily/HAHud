HAHud
=====

HAHud is a small reusable piece of code that provides you with a configurable replacement to the UIAlertView concept. Its main features are:

  * Large and variable size text
  * Choice of activity viewer, progress bar, check/cross or buttons
  * Any number of buttons
  * Buttons side by side or stacked vertically
  * Simple block-based callbacks
  * Can be automatically dismissed after a specified interval

HAHud started as a replacement to ATMHud but is significantly simpler and more modern.
It heavily utilises constraints, which makes it suited to iOS 7.
However, do note that **it doesn't currently use ARC** but can be easily converted. After all, it is only a few hundred lines of code.

Installation
------------

Drag the `HAHud` group into your project. It consists of the `HAHud.h` and `HAHud.m` files as well as a few images.


Usage
-----

See the sample project's `HAHUDViewController` for sample usage.

Also see `HAHud.h` for more information.

The basic technique for a side-by-side 2-button alert is as follows:

```
HAHud * hud = [HAHud hudWithButtonTitles:@[@"Cancel", @"OK"] stacked:NO];
[hud setCompletion:^(NSUInteger bTag) {
    NSLog(@"You tapped button # %lu", (unsigned long)bTag);
}];
hud.message.text = msg;
hud.parentView = self.view;
[hud show];
```

Here's another with a progress bar:

```
HAHud * hud = [HAHud hudWithProgressRate:0.3f];
hud.message.text = msg;
hud.parentView = self.view;
[hud show];

// And later on in your code...
hud.progressView.progress = 0.7f;

// And still later...
hud.progressView.progress = 1.f;
[hud dismiss];

```

Notes
-----

 1. If you don't specify the `parentView`, the hud will show on the window. That works **only in the default orientation**. The window has no understanding of orientation changes, so the hud will show in the default orientation. To fix that, simply assign `parentView` to be the main view of your current view controller. The hud will then orient with your main view.

 2. The hud will automatically dismiss itself when a button is tapped.

 3. Do not try to reuse a `HAHud` object (for example showing it again inside the completion block of the button taps). You should have no expectation that the `HAHud` object is still alive after having configured and shown the hud. Simple create a new one whenever you need it.

