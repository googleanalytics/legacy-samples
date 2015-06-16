//
//  SettingsViewController.h
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

@interface SettingsViewController : UIViewController {
 @private
  IBOutlet  UITextField*  webPropertyIdField_;
  IBOutlet  UITextField*  referrerField_;
  IBOutlet  UISlider*     dispatchPeriodSlider_;
  IBOutlet  UILabel*      dispatchPeriodLabel_;
  IBOutlet  UISwitch*     anonymizeIpSwitch_;
  IBOutlet  UISwitch*     debugSwitch_;
  IBOutlet  UISwitch*     dryrunSwitch_;
  IBOutlet  UIButton*     startStopTrackingButton_;
  IBOutlet  UIButton*     dispatchHitsButton_;
  IBOutlet  UIButton*     dispatchHitsSyncButton_;
  IBOutlet  UIButton*     backgroundButton_;
}

@property (retain, nonatomic) UITextField*  webPropertyIdField;
@property (retain, nonatomic) UITextField*  referrerField;
@property (retain, nonatomic) UISlider*     dispatchPeriodSlider;
@property (retain, nonatomic) UIButton*     startStopTrackingButton;
@property (retain, nonatomic) UIButton*     dispatchHitsButton;
@property (retain, nonatomic) UIButton*     dispatchHitsSyncButton;
@property (retain, nonatomic) UIButton*     backgroundButton;
@property (retain, nonatomic) UISwitch*     anonymizeIpSwitch;
@property (retain, nonatomic) UISwitch*     debugSwitch;
@property (retain, nonatomic) UISwitch*     dryrunSwitch;

- (IBAction)controlUpdated:(id)sender;
- (IBAction)backgroundButtonClicked:(id)sender;
- (IBAction)startStopTrackingClicked:(id)sender;
- (IBAction)dispatchButtonClicked:(id)sender;
- (BOOL)textFieldShouldReturn:(UITextField*)textField;

@end
