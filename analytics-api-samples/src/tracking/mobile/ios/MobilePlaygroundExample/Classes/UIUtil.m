//
//  UIUtil.m
//  MobilePlayground
//
//  Copyright 2011 Google, Inc. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "UIUtil.h"

@implementation UIUtil

#define kBlackColor [UIColor blackColor]
#define kGrayColor  [UIColor grayColor]
#define kBlueColor  \
    [UIColor colorWithRed:(50/255.) green:(79/255.) blue:(139/255.) alpha:1.0]

+ (void)enableOrDisableControl:(UIControl *)control isEnabled:(BOOL)enabled {
  control.userInteractionEnabled = enabled;
  control.enabled = enabled;
  if ([control isKindOfClass:[UITextField class]]) {
    UITextField *text = (UITextField *)control;
    UIColor *color = enabled ? kBlackColor : kGrayColor;
    text.textColor = color;
  } else if ([control isKindOfClass:[UIButton class]]) {
    UIButton *button = (UIButton *)control;
    UIColor *color = enabled ? kBlueColor : kGrayColor;
    [button setTitleColor:color forState:UIControlStateNormal];
  }
}

+ (void)updateIntegerField:(UITextField *)textField intValue:(int *)value {
  *value = (int)strtoul([[textField text] UTF8String], NULL, 10);
  textField.text = [NSString stringWithFormat:@"%d", *value];
}

+ (void)updateDecimalField:(UITextField *)textField
              decimalValue:(double *)value {
  double realValue = strtod([[textField text] UTF8String], NULL);
  *value = ((int)(realValue * 100)) / 100.;
  textField.text = [NSString stringWithFormat:@"%.2f", *value];
}

@end

@implementation AlertDialog

static BOOL showingAlert = NO;

+ (void)alertWithTitle:(NSString *)title
            andMessage:(NSString *)message
          dismissAfter:(NSTimeInterval)interval {
  if (showingAlert) {
    // Ignore alerts when we already have an alert on the screen.
    NSLog(@"Ignoring alert '%@' because there is already an alert on screen.",
        message);
    return;
  }
  AlertDialog *alert = [[AlertDialog alloc] initWithTitle:title
                                               andMessage:message
                                             dismissAfter:interval];
  showingAlert = YES;
  [alert show];
  [alert release];
}

- (id)initWithTitle:(NSString *)title
         andMessage:(NSString *)message
       dismissAfter:(NSTimeInterval)interval {
  if ((self = [super initWithTitle:title
                           message:message
                          delegate:self
                 cancelButtonTitle:@"Dismiss"
                 otherButtonTitles:nil])) {
    [self performSelector:@selector(dismissAfterDelay)
               withObject:nil
               afterDelay:interval];
  }
  return self;
}

- (void)dismissAfterDelay {
  if (showingAlert) {
    NSLog(@"dismissAfterDelay triggered dialog dimissal.");
    [self dismissWithClickedButtonIndex:0 animated:YES];
  } else {
    NSLog(@"dismissAfterDelay ignored.");
  }
}

- (void)alertView:(UIAlertView *)alertView
    didDismissWithButtonIndex:(NSInteger)buttonIndex {
  NSLog(@"Dialog dimissed with button index %d", buttonIndex);
  assert(showingAlert);
  showingAlert = NO;
}

@end
