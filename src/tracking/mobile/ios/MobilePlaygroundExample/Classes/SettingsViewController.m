//
//  SettingsViewController.m
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

#import "SettingsViewController.h"

#import "GANTracker.h"
#import "MobilePlaygroundAppDelegate.h"
#import "TrackerUtil.h"
#import "UIUtil.h"

static NSString* const kStartTracking = @"Start Tracking";
static NSString* const kStopTracking = @"Stop Tracking";
static NSString* const kWebPropertyKey = @"gaWebProperty";
static NSString* const kDispatchPeriodKey = @"gaDispatchPeriod";
static NSString* const kReferrerUrlKey = @"gaReferrerUrl";
static NSString* const kAnonymizeIpKey = @"gaAnonymizeIp";
static NSString* const kDebugKey = @"gaDebug";
static NSString* const kDryrunKey = @"gaDryrun";
static const int kDefaultDispatchPeriod = 10;

static const NSTimeInterval kDefaultErrorDismissDelay = 3;

@implementation SettingsViewController

@synthesize webPropertyIdField = webPropertyIdField_;
@synthesize referrerField = referrerField_;
@synthesize dispatchPeriodSlider = dispatchPeriodSlider_;
@synthesize anonymizeIpSwitch = anonymizeIpSwitch_;
@synthesize debugSwitch = debugSwitch_;
@synthesize dryrunSwitch = dryrunSwitch_;
@synthesize startStopTrackingButton = startStopTrackingButton_;
@synthesize dispatchHitsButton = dispatchHitsButton_;
@synthesize dispatchHitsSyncButton = dispatchHitsSyncButton_;
@synthesize backgroundButton = backgroundButton_;

- (void)viewDidLoad {
  [super viewDidLoad];

  NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
  if ([defaults objectForKey:kWebPropertyKey] != nil) {
    webPropertyIdField_.text = [defaults stringForKey:kWebPropertyKey];
  }
  if ([defaults objectForKey:kDispatchPeriodKey] != nil) {
    dispatchPeriodSlider_.value = [defaults integerForKey:kDispatchPeriodKey];
  } else {
    dispatchPeriodSlider_.value = kDefaultDispatchPeriod;
  }
  if ([defaults objectForKey:kReferrerUrlKey] != nil) {
    referrerField_.text = [defaults stringForKey:kReferrerUrlKey];
  }
  if ([defaults objectForKey:kAnonymizeIpKey] != nil) {
    anonymizeIpSwitch_.on = [defaults boolForKey:kAnonymizeIpKey];
  }
  if ([defaults objectForKey:kDebugKey] != nil) {
    debugSwitch_.on = [defaults boolForKey:kDebugKey];
  }
  if ([defaults objectForKey:kDryrunKey] != nil) {
    dryrunSwitch_.on = [defaults boolForKey:kDryrunKey];
  }
  // Web property IDs consist of at least "UA-". If it's clear that the id
  // needs to be supplied, set the focus to the web property id field.
  if (webPropertyIdField_.text.length <= 3) {
    [webPropertyIdField_ becomeFirstResponder];
  }
  // Initialize tracker properties to be consistent with what's in the UI.
  [GANTracker sharedTracker].anonymizeIp = anonymizeIpSwitch_.isOn;
  [GANTracker sharedTracker].debug = debugSwitch_.isOn;
  [GANTracker sharedTracker].dryRun = dryrunSwitch_.isOn;

  // Fake an update from the dispatch period slider so that the dispatch period
  // label gets updated.
  [self controlUpdated:dispatchPeriodSlider_];
  // Ensure dispatch buttons are enabled or disabled according to tracker state.
  BOOL isTracking = [MobilePlaygroundAppDelegate sharedDelegate].isTracking;
  [UIUtil enableOrDisableControl:dispatchHitsButton_ isEnabled:isTracking];
  [UIUtil enableOrDisableControl:dispatchHitsSyncButton_ isEnabled:isTracking];
}

- (IBAction)controlUpdated:(id)sender {
  if (sender == webPropertyIdField_) {
    assert([MobilePlaygroundAppDelegate sharedDelegate].isTracking == NO);
    [[NSUserDefaults standardUserDefaults] setObject:webPropertyIdField_.text
                                              forKey:kWebPropertyKey];
    NSLog(@"Web property updated to: %@", webPropertyIdField_.text);
  } else if (sender == referrerField_) {
    [[NSUserDefaults standardUserDefaults] setObject:referrerField_.text
                                              forKey:kReferrerUrlKey];
    NSLog(@"Referrer updated to: %@", referrerField_.text);
  } else if (sender == dispatchPeriodSlider_) {
    assert([MobilePlaygroundAppDelegate sharedDelegate].isTracking == NO);
    int value = (int)dispatchPeriodSlider_.value;
    [[NSUserDefaults standardUserDefaults] setInteger:value
                                               forKey:kDispatchPeriodKey];
    dispatchPeriodSlider_.value = value;
    if (value == 0) {
      dispatchPeriodLabel_.text = @"Off";
    } else {
      dispatchPeriodLabel_.text = [NSString stringWithFormat:@"%d Sec", value];
    }
    NSLog(@"Dispatch period updated to: %d", value);
  } else if (sender == anonymizeIpSwitch_) {
    [GANTracker sharedTracker].anonymizeIp = anonymizeIpSwitch_.isOn;
    [[NSUserDefaults standardUserDefaults] setBool:anonymizeIpSwitch_.isOn
                                            forKey:kAnonymizeIpKey];
    NSLog(@"Anonymize IP updated to: %d", anonymizeIpSwitch_.isOn);
  } else if (sender == debugSwitch_) {
    [GANTracker sharedTracker].debug = debugSwitch_.isOn;
    [[NSUserDefaults standardUserDefaults] setBool:debugSwitch_.isOn
                                            forKey:kDebugKey];
    NSLog(@"Debug updated to: %d", debugSwitch_.isOn);
  } else if (sender == dryrunSwitch_) {
    [GANTracker sharedTracker].dryRun = dryrunSwitch_.isOn;
    [[NSUserDefaults standardUserDefaults] setBool:dryrunSwitch_.isOn
                                            forKey:kDryrunKey];
    NSLog(@"DryRun updated to: %d", debugSwitch_.isOn);
  } else {
    NSLog(@"Received event from unknown control: %@", sender);
  }
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)backgroundButtonClicked:(id)sender {
  assert((UIButton*)sender == backgroundButton_);
  [self.view endEditing:YES];
}

- (IBAction)startStopTrackingClicked:(id)sender {
  assert((UIButton*)sender == startStopTrackingButton_);
  if ([MobilePlaygroundAppDelegate sharedDelegate].isTracking == YES) {
    // Stop tracking.
    [[GANTracker sharedTracker] stopTracker];
    [MobilePlaygroundAppDelegate sharedDelegate].isTracking = NO;
    // Re-enable editing of web property id field and dispatch period.
    [UIUtil enableOrDisableControl:webPropertyIdField_ isEnabled:YES];
    [UIUtil enableOrDisableControl:dispatchPeriodSlider_ isEnabled:YES];
    [UIUtil enableOrDisableControl:dispatchHitsButton_ isEnabled:NO];
    [UIUtil enableOrDisableControl:dispatchHitsSyncButton_ isEnabled:NO];
    // Update button label.
    [startStopTrackingButton_ setTitle:kStartTracking
                              forState:UIControlStateNormal];
  } else {
    // Start tracking.
    MobilePlaygroundAppDelegate* delegate = (MobilePlaygroundAppDelegate*)
        [[UIApplication sharedApplication] delegate];
    [[GANTracker sharedTracker]
        startTrackerWithAccountID:webPropertyIdField_.text
                   dispatchPeriod:(int)dispatchPeriodSlider_.value
                         delegate:delegate];
    [MobilePlaygroundAppDelegate sharedDelegate].isTracking = YES;
    if (referrerField_.text.length != 0) {
      NSError* error = nil;
      if (![[GANTracker sharedTracker] setReferrer:referrerField_.text
                                         withError:&error]) {
        NSLog(@"Failed to set referrer: %@", error);
        [AlertDialog alertWithTitle:@"Referrer Error"
                         andMessage:[TrackerUtil trackerErrorString:error]
                       dismissAfter:kDefaultErrorDismissDelay];
      }
    }
    // Disable editing of web property id field.
    [UIUtil enableOrDisableControl:webPropertyIdField_ isEnabled:NO];
    [UIUtil enableOrDisableControl:dispatchPeriodSlider_ isEnabled:NO];
    [UIUtil enableOrDisableControl:dispatchHitsButton_ isEnabled:YES];
    [UIUtil enableOrDisableControl:dispatchHitsSyncButton_ isEnabled:YES];
    // Update button label.
    [startStopTrackingButton_ setTitle:kStopTracking
                              forState:UIControlStateNormal];
  }
}

- (IBAction)dispatchButtonClicked:(id)sender {
  assert([MobilePlaygroundAppDelegate sharedDelegate].isTracking == YES);
  if (sender == dispatchHitsButton_) {
    [[GANTracker sharedTracker] dispatch];
  } else {
    assert(sender == dispatchHitsSyncButton_);
    [[GANTracker sharedTracker] dispatchSynchronous:3.0];
  }
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
  [textField resignFirstResponder];
  return NO;
}

@end
