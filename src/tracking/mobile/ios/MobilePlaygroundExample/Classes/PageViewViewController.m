//
//  PageViewViewController.m
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

#import "PageViewViewController.h"

#import "GANTracker.h"
#import "TrackerUtil.h"
#import "UIUtil.h"

static const NSTimeInterval kDefaultErrorDismissDelay = 3;

@implementation PageViewViewController

@synthesize urlField = urlField_;
@synthesize submitHitButton = submitHitButton_;
@synthesize backgroundButton = backgroundButton_;

- (IBAction)submitHitButtonClicked:(id)sender {
  assert(sender == submitHitButton_);
  NSError* error = nil;
  if (![[GANTracker sharedTracker] trackPageview:[urlField_ text]
                                       withError:&error]) {
    NSLog(@"Track page view error: %@", error);
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
