//
//  CommerceViewController.h
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

@interface CommerceViewController : UIViewController {
 @private
  IBOutlet UIButton*     resetButton_;
  IBOutlet UIButton*     checkoutButton_;
  IBOutlet UIButton*     backgroundButton_;
  IBOutlet UITextField*  shieldTextField_;
  IBOutlet UITextField*  swordTextField_;
  IBOutlet UITextField*  spellTextField_;
  IBOutlet UITextField*  shippingTextField_;
  IBOutlet UITextField*  taxTextField_;
  IBOutlet UITextField*  totalTextField_;

  int     shieldQty_;
  int     swordQty_;
  int     spellQty_;
  double  shippingCharge_;
  double  taxAmount_;
  double  totalCost_;
  int     orderId_;
}
@property (retain, nonatomic) UIButton* resetButton;
@property (retain, nonatomic) UIButton* checkoutButton;
@property (retain, nonatomic) UIButton* backgroundButton;
@property (retain, nonatomic) UITextField* shieldText;
@property (retain, nonatomic) UITextField* swordText;
@property (retain, nonatomic) UITextField* spellText;
@property (retain, nonatomic) UITextField* shippingText;
@property (retain, nonatomic) UITextField* taxText;
@property (retain, nonatomic) UITextField* totalText;
@property (assign, nonatomic) int shieldQty;
@property (assign, nonatomic) int swordQty;
@property (assign, nonatomic) int spellQty;
@property (assign, nonatomic) double shippingCharge;
@property (assign, nonatomic) double taxAmount;

- (IBAction)resetButtonClicked:(id)sender;
- (IBAction)checkoutButtonClicked:(id)sender;
- (IBAction)textValueChanged:(id)sender;
- (IBAction)backgroundButtonClicked:(id)sender;
- (void)recomputeTotal;
@end
