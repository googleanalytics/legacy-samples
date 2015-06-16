//
//  MobilePlaygroundAppDelegate.m
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

#import "MobilePlaygroundAppDelegate.h"

#import "UIUtil.h"

static const NSTimeInterval kDefaultErrorDismissDelay = 2;

@implementation MobilePlaygroundAppDelegate

@synthesize window = window_;
@synthesize tabBarController = tabBarController_;
@synthesize isTracking = isTracking_;

+ (MobilePlaygroundAppDelegate *)sharedDelegate {
  return (MobilePlaygroundAppDelegate *)
      [[UIApplication sharedApplication] delegate];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:
    (NSDictionary *)launchOptions {
  isTracking_ = NO;
  // Add the tab bar controller's view to the window and display.
  [self.window addSubview:self.tabBarController.view];
  [self.window makeKeyAndVisible];
  return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
  self.tabBarController = nil;
  self.window = nil;
  [super dealloc];
}

#pragma mark -
#pragma mark GANTrackerDelegate methods

- (void)hitDispatched:(NSString *)hitString {
  NSLog(@"Hits dispatched: %@", hitString);
}

- (void)trackerDispatchDidComplete:(GANTracker *)tracker
                  eventsDispatched:(NSUInteger)hitsDispatched
              eventsFailedDispatch:(NSUInteger)hitsFailedDispatch {
  NSLog(@"Dispatched events: %u", hitsDispatched);
  NSLog(@"Failed dispatch: %u", hitsFailedDispatch);
  if (hitsFailedDispatch > 0) {
    NSString* errorString = [NSString
        stringWithFormat:@"%u events failed to dispatch and will be "
                          "retried on the next dispatch.",
        hitsFailedDispatch];
    [AlertDialog alertWithTitle:@"Dispatch Failed"
                     andMessage:errorString
                   dismissAfter:kDefaultErrorDismissDelay];
  }
}

@end
