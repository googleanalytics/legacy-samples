//
//  CommerceViewController.m
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

#import "CommerceViewController.h"

#import "GANTracker.h"
#import "TrackerUtil.h"
#import "UIUtil.h"

static NSString* const kStoreName = @"Analytics Tester Store";

static const double kShieldPrice = 2.0;
static const double kSwordPrice = 3.5;
static const double kSpellPrice = 5.0;

static NSString* const kShieldSku = @"123456";
static NSString* const kSwordSku =  @"123457";
static NSString* const kSpellSku =  @"123458";

static NSString* const kShieldName = @"Shield";
static NSString* const kSwordName =  @"Sword";
static NSString* const kSpellName =  @"Spell";

static NSString* const kShieldCategory = @"Defense";
static NSString* const kSwordCategory =  @"Offense";
static NSString* const kSpellCategory =  @"Magic";

static const NSTimeInterval kDefaultErrorDismissDelay = 3;

@implementation CommerceViewController

@synthesize resetButton = resetButton_;
@synthesize checkoutButton = checkoutButton_;
@synthesize backgroundButton = backgroundButton_;
@synthesize shieldText = shieldTextField_;
@synthesize swordText = swordTextField_;
@synthesize spellText = spellTextField_;
@synthesize shippingText = shippingTextField_;
@synthesize taxText = taxTextField_;
@synthesize totalText = totalTextField_;
@synthesize shieldQty = shieldQty_;
@synthesize swordQty = swordQty_;
@synthesize spellQty = spellQty_;
@synthesize shippingCharge = shippingCharge_;
@synthesize taxAmount = taxAmount_;

// Implement viewDidLoad to do additional setup after loading the view,
// typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  shieldQty_ = 0;
  swordQty_ = 0;
  spellQty_ = 0;
  shippingCharge_ = 0;
  taxAmount_ = 0;
  orderId_ = 0;
  [self recomputeTotal];
  // TODO(fmela): why can't this be set in IB?
  shippingTextField_.keyboardType = UIKeyboardTypeDecimalPad;
  taxTextField_.keyboardType = UIKeyboardTypeDecimalPad;
  [UIUtil enableOrDisableControl:checkoutButton_ isEnabled:NO];
}

- (IBAction)resetButtonClicked:(id)sender {
  shieldQty_ = swordQty_ = spellQty_ = 0;
  shippingCharge_ = taxAmount_ = totalCost_ = 0.0;
  shieldTextField_.text = @"0";
  swordTextField_.text = @"0";
  spellTextField_.text = @"0";
  shippingTextField_.text = @"0.00";
  taxTextField_.text = @"0.00";
  totalTextField_.text = @"0.00";
  [UIUtil enableOrDisableControl:checkoutButton_ isEnabled:NO];
}

- (IBAction)checkoutButtonClicked:(id)sender {
  NSLog(@"Checkout button clicked!");
  GANTracker* tracker = [GANTracker sharedTracker];
  // TODO(fmela): ensure tracker is tracking first.
  NSString* orderIdString =
      [NSString stringWithFormat:@"Tester Order #%d", ++orderId_];
  NSError* error = nil;
  if (![tracker addTransaction:orderIdString
                    totalPrice:totalCost_
                     storeName:kStoreName
                      totalTax:taxAmount_
                  shippingCost:shippingCharge_
                     withError:&error]) {
    NSLog(@"Error adding transaction: %@", error);
    [AlertDialog alertWithTitle:@"Transaction Error"
                     andMessage:[TrackerUtil trackerErrorString:error]
                   dismissAfter:kDefaultErrorDismissDelay];
    return;
  }
  if (shieldQty_ > 0 && ![tracker addItem:orderIdString
                                  itemSKU:kShieldSku
                                itemPrice:kShieldPrice
                                itemCount:shieldQty_
                                 itemName:kShieldName
                             itemCategory:kShieldCategory
                                withError:&error]) {
    NSLog(@"Error adding shield(s): %@", error);
    [AlertDialog alertWithTitle:@"Item Error"
                     andMessage:[TrackerUtil trackerErrorString:error]
                   dismissAfter:kDefaultErrorDismissDelay];
    [tracker clearTransactions:NULL];
    return;
  }
  if (swordQty_ > 0 && ![tracker addItem:orderIdString
                                  itemSKU:kSwordSku
                                itemPrice:kSwordPrice
                                itemCount:swordQty_
                                 itemName:kSwordName
                             itemCategory:kSwordCategory
                                withError:&error]) {
    NSLog(@"Error adding sword(s): %@", error);
    [AlertDialog alertWithTitle:@"Item Error"
                     andMessage:[TrackerUtil trackerErrorString:error]
                   dismissAfter:kDefaultErrorDismissDelay];
    [tracker clearTransactions:NULL];
    return;
  }
  if (spellQty_ > 0 && ![tracker addItem:orderIdString
                                 itemSKU:kSpellSku
                               itemPrice:kSpellPrice
                               itemCount:spellQty_
                                itemName:kSpellName
                            itemCategory:kSpellCategory
                               withError:&error]) {
    NSLog(@"Error adding spell(s): %@", error);
    [AlertDialog alertWithTitle:@"Item Error"
                     andMessage:[TrackerUtil trackerErrorString:error]
                   dismissAfter:kDefaultErrorDismissDelay];
    [tracker clearTransactions:NULL];
    return;
  }

  if (![tracker trackTransactions:&error]) {
    NSLog(@"Error tracking transaction(s): %@", error);
    [AlertDialog alertWithTitle:@"Transaction Tracking Error"
                     andMessage:[TrackerUtil trackerErrorString:error]
                   dismissAfter:kDefaultErrorDismissDelay];
    [tracker clearTransactions:NULL];
    return;
  }
  // Reset all fields.
  [self resetButtonClicked:resetButton_];
}

- (IBAction)textValueChanged:(id)sender {
  assert([sender isKindOfClass:[UITextField class]]);
  UITextField* text = (UITextField*)sender;
  if (text == shieldTextField_) {
    NSLog(@"Shield value changed to %@", [text text]);
    [UIUtil updateIntegerField:text intValue:&shieldQty_];
    NSLog(@"Shield quantity is now %d", shieldQty_);
  } else if (text == swordTextField_) {
    NSLog(@"Sword value changed to %@", [text text]);
    [UIUtil updateIntegerField:text intValue:&swordQty_];
    NSLog(@"Sword quantity is now %d", swordQty_);
  } else if (text == spellTextField_) {
    NSLog(@"Spell value changed to %@", [text text]);
    [UIUtil updateIntegerField:text intValue:&spellQty_];
    NSLog(@"Spell quantity is now %d", spellQty_);
  } else if (text == shippingTextField_) {
    NSLog(@"Shipping value changed to %@", [text text]);
    [UIUtil updateDecimalField:text decimalValue:&shippingCharge_];
    NSLog(@"Shipping charge is now %f", shippingCharge_);
  } else {
    assert(text == taxTextField_);
    NSLog(@"Tax value changed to %@", [text text]);
    [UIUtil updateDecimalField:text decimalValue:&taxAmount_];
    NSLog(@"Tax amount is now %f", taxAmount_);
  }
  [self recomputeTotal];
  [UIUtil enableOrDisableControl:checkoutButton_
                       isEnabled:(swordQty_ + shieldQty_ + spellQty_ > 0)];

  [text resignFirstResponder];
}

- (IBAction)backgroundButtonClicked:(id)sender {
  [self.view endEditing:YES];
}

- (void)recomputeTotal {
  totalCost_ = shieldQty_ * kShieldPrice + swordQty_ * kSwordPrice +
      spellQty_ * kSpellPrice + shippingCharge_ + taxAmount_;
  NSLog(@"Total cost is now %f", totalCost_);
  totalTextField_.text = [NSString stringWithFormat:@"%.2f", totalCost_];
}

@end
