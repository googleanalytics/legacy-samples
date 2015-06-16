//
//  UIUtil.h
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

#import <UIKit/UIKit.h>

@interface UIUtil : NSObject

// Enable or disable a UIControl. If the control is a text field or a button,
// it will be grayed out when disabled.
+ (void)enableOrDisableControl:(UIControl*)control isEnabled:(BOOL)enabled;

// Parses a non-negative integer value from 'textfield' and stores it in
// 'value' (negative values or malformed strings will cause zero to be returned
// in 'value'). Updates 'textField' to reflect the parsed value. This will
// eliminate any whitespace.
+ (void)updateIntegerField:(UITextField*)textField intValue:(int *)value;

// Parses a real value with up to 2 decimal places from 'textfield' and stores
// it in 'value' (malformed strings will cause zero to be returned in 'value').
// Updates 'textField' to reflect the parsed value. This will eliminate any
// whitespace.
+ (void)updateDecimalField:(UITextField*)textField decimalValue:(double *)value;

@end

@interface AlertDialog : UIAlertView<UIAlertViewDelegate>

// Display a modal alert dialog with title 'title' and message 'message' for no
// more than 'interval' seconds. The dialog will have a single "Dismiss" button
// at the bottom which can be pressed to dismiss the dialog early.
+ (void)alertWithTitle:(NSString *)title
            andMessage:(NSString *)message
          dismissAfter:(NSTimeInterval)interval;

- (id)initWithTitle:(NSString *)title
         andMessage:(NSString *)message
       dismissAfter:(NSTimeInterval)interval;

- (void)dismissAfterDelay;
- (void)alertView:(UIAlertView *)alertView
    didDismissWithButtonIndex:(NSInteger)buttonIndex;

@end
