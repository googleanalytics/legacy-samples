//
//  MobilePlaygroundAppDelegate.h
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

#import "GANTracker.h"

@interface MobilePlaygroundAppDelegate : NSObject <UIApplicationDelegate,
                                                   UITabBarControllerDelegate,
                                                   GANTrackerDelegate> {
@private
  // UI Elements.
  UIWindow* window_;
  UITabBarController* tabBarController_;
  BOOL isTracking_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, assign) BOOL isTracking;

+ (MobilePlaygroundAppDelegate*)sharedDelegate;

@end
