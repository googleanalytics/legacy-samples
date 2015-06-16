//
//  TrackerUtil.m
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

#import "TrackerUtil.h"

#import "GANTracker.h"

static NSString* const kInvalidInput =
    @"Invalid input.";
static NSString* const kEventsPerSessionLimit =
    @"Exceeded limit on number of hits per session.";
static NSString* const kTrackerNotStarted =
    @"Tracker not started.";
static NSString* const kDatabaseError =
    @"Database error.";

@implementation TrackerUtil

+ (NSString*)trackerErrorString:(NSError*)error {
  switch ([error code]) {
    // This error code is returned when input to a method is incorrect.
    case kGANTrackerInvalidInputError:
      return kInvalidInput;

    // This error code is returned when the number of hits generated in a
    // session exceeds the limit (currently 500).
    case kGANTrackerEventsPerSessionLimitError:
      return kEventsPerSessionLimit;

    // This error code is returned if the method called requires that the
    // tracker be started.
    case kGANTrackerNotStartedError:
      return kTrackerNotStarted;

    // This error code is returned if the method call resulted in some sort of
    // database error.
    case kGANTrackerDatabaseError:
      return kDatabaseError;

    // Unknown error code, so return the description from the error object.
    default:
      return [error localizedDescription];
  }
}

@end
