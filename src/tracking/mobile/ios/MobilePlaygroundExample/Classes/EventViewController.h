//
//  EventViewController.h
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

@interface EventViewController : UIViewController {
 @private
  IBOutlet UITextField* categoryField_;
  IBOutlet UITextField* actionField_;
  IBOutlet UITextField* labelField_;
  IBOutlet UILabel*     valueLabel_;
  IBOutlet UITextField* valueField_;
  IBOutlet UIButton*    submitEventButton_;
  IBOutlet UIButton*    backgroundButton_;
  int                   value_;
}

@property (nonatomic, retain) UITextField*  categoryField;
@property (nonatomic, retain) UITextField*  actionField;
@property (nonatomic, retain) UITextField*  labelField;
@property (nonatomic, retain) UILabel*      valueLabel;
@property (nonatomic, retain) UITextField*  valueField;
@property (nonatomic, retain) UIButton*     submitEventButton;
@property (nonatomic, retain) UIButton*     backgroundButton;

- (IBAction)textFieldUpdated:(id)sender;
- (IBAction)submitEventButtonClicked:(id)sender;
- (IBAction)backgroundButtonClicked:(id)sender;
- (BOOL)textFieldShouldReturn:(UITextField*)textField;

@end
