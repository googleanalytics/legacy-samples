//
//  CustomVariablesViewController.h
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

#import "CustomVariablesViewController.h"

@interface CustomVariablesViewController : UIViewController {
 @private
  IBOutlet UIButton*            backgroundButton_;

  IBOutlet UITextField*         var1Name_;
  IBOutlet UITextField*         var1Value_;
  IBOutlet UISegmentedControl*  var1Scope_;

  IBOutlet UITextField*         var2Name_;
  IBOutlet UITextField*         var2Value_;
  IBOutlet UISegmentedControl*  var2Scope_;

  IBOutlet UITextField*         var3Name_;
  IBOutlet UITextField*         var3Value_;
  IBOutlet UISegmentedControl*  var3Scope_;

  IBOutlet UITextField*         var4Name_;
  IBOutlet UITextField*         var4Value_;
  IBOutlet UISegmentedControl*  var4Scope_;

  IBOutlet UITextField*         var5Name_;
  IBOutlet UITextField*         var5Value_;
  IBOutlet UISegmentedControl*  var5Scope_;
}

@property (nonatomic, retain) UIButton*           backgroundButton;
@property (nonatomic, retain) UITextField*        var1Name;
@property (nonatomic, retain) UITextField*        var1Value;
@property (nonatomic, retain) UISegmentedControl* var1Scope;
@property (nonatomic, retain) UITextField*        var2Name;
@property (nonatomic, retain) UITextField*        var2Value;
@property (nonatomic, retain) UISegmentedControl* var2Scope;
@property (nonatomic, retain) UITextField*        var3Name;
@property (nonatomic, retain) UITextField*        var3Value;
@property (nonatomic, retain) UISegmentedControl* var3Scope;
@property (nonatomic, retain) UITextField*        var4Name;
@property (nonatomic, retain) UITextField*        var4Value;
@property (nonatomic, retain) UISegmentedControl* var4Scope;
@property (nonatomic, retain) UITextField*        var5Name;
@property (nonatomic, retain) UITextField*        var5Value;
@property (nonatomic, retain) UISegmentedControl* var5Scope;

- (IBAction)nameUpdated:(id)sender;
- (IBAction)valueUpdated:(id)sender;
- (IBAction)scopeUpdated:(id)sender;
- (IBAction)backgroundButtonClicked:(id)sender;
- (BOOL)textFieldShouldReturn:(UITextField*)textField;

@end
