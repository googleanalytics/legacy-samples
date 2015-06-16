//
//  EventViewController.m
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

#import "EventViewController.h"

#import "GANTracker.h"
#import "TrackerUtil.h"
#import "UIUtil.h"

static const NSTimeInterval kDefaultErrorDismissDelay = 3;

@implementation EventViewController

@synthesize categoryField = categoryField_;
@synthesize actionField = actionField_;
@synthesize labelField = labelField_;
@synthesize valueLabel = valueLabel_;
@synthesize valueField = valueField_;
@synthesize submitEventButton = submitEventButton_;
@synthesize backgroundButton = backgroundButton_;

// Implement viewDidLoad to do additional setup after loading the view,
// typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  value_ = -1;
  [UIUtil enableOrDisableControl:submitEventButton_ isEnabled:NO];
}

- (IBAction)textFieldUpdated:(id)sender {
  assert(sender == valueField_);
  BOOL enabled = categoryField_.text.length > 0 && actionField_.text.length > 0;
  if ([valueField_.text length] > 0) {
    const char *valueStr = [valueField_.text UTF8String];
    char *strp;
    value_ = (int)strtoul(valueStr, &strp, 10);
    if (value_ < 0 || strp == valueStr || *strp != '\0') {
      NSLog(@"Invalid string in value field.");
      // Didn't parse a valid value from 'value', or there is trailing garbage.
      // Ensure the submit button is not enabled, and highlight the value label.
      value_ = -1;
      enabled = FALSE;
      valueLabel_.textColor = [UIColor redColor];
    } else {
      NSLog(@"Parsed value %d from value field.", value_);
      valueLabel_.textColor = [UIColor blackColor];
    }
  } else {
    value_ = -1;
    valueLabel_.textColor = [UIColor blackColor];
  }
  [UIUtil enableOrDisableControl:submitEventButton_ isEnabled:enabled];
}

- (IBAction)submitEventButtonClicked:(id)sender {
  assert(sender == submitEventButton_);
  assert(categoryField_.text.length > 0);
  assert(actionField_.text.length > 0);
  NSString* label = labelField_.text.length > 0 ? labelField_.text : nil;
  NSError* error = nil;
  if (![[GANTracker sharedTracker] trackEvent:categoryField_.text
                                       action:actionField_.text
                                        label:label
                                        value:value_
                                    withError:&error]) {
    NSLog(@"Track event error: %@", error);
    [AlertDialog alertWithTitle:@"Tracking Error"
                     andMessage:[TrackerUtil trackerErrorString:error]
                   dismissAfter:kDefaultErrorDismissDelay];
  }
}

- (IBAction)backgroundButtonClicked:(id)sender {
  assert(sender == backgroundButton_);
  [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
  [textField resignFirstResponder];
  return NO;
}

@end
