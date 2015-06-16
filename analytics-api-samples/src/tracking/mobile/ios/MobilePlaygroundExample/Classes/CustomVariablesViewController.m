//
//  CustomVariablesViewController.m
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

#import "CustomVariablesViewController.h"

#import "GANTracker.h"
#import "TrackerUtil.h"
#import "UIUtil.h"

static const NSTimeInterval kDefaultErrorDismissDelay = 3;

@interface CustomVariablesViewController ()
- (void)updateCustomVariableWithNameField:(UITextField *)nameField
                            andValueField:(UITextField *)valueField
                            andScopeField:(UISegmentedControl *)scopeField;
@end

@implementation CustomVariablesViewController

@synthesize backgroundButton = backgroundButton_;
@synthesize var1Name = var1Name_;
@synthesize var1Value = var1Value_;
@synthesize var1Scope = var1Scope_;
@synthesize var2Name = var2Name_;
@synthesize var2Value = var2Value_;
@synthesize var2Scope = var2Scope_;
@synthesize var3Name = var3Name_;
@synthesize var3Value = var3Value_;
@synthesize var3Scope = var3Scope_;
@synthesize var4Name = var4Name_;
@synthesize var4Value = var4Value_;
@synthesize var4Scope = var4Scope_;
@synthesize var5Name = var5Name_;
@synthesize var5Value = var5Value_;
@synthesize var5Scope = var5Scope_;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
  self.backgroundButton = nil;
  self.var1Name = nil;
  self.var1Value = nil;
  self.var1Scope = nil;
  self.var2Name = nil;
  self.var2Value = nil;
  self.var2Scope = nil;
  self.var3Name = nil;
  self.var3Value = nil;
  self.var3Scope = nil;
  self.var4Name = nil;
  self.var4Value = nil;
  self.var4Scope = nil;
  self.var5Name = nil;
  self.var5Value = nil;
  self.var5Scope = nil;
  [super dealloc];
}

- (IBAction)nameUpdated:(id)sender {
  assert([sender isKindOfClass:[UITextField class]]);
  UITextField *nameField = (UITextField *)sender;
  [self updateCustomVariableWithNameField:nameField
                            andValueField:nil
                            andScopeField:nil];
}

- (IBAction)valueUpdated:(id)sender {
  assert([sender isKindOfClass:[UITextField class]]);
  UITextField *valueField = (UITextField *)sender;
  [self updateCustomVariableWithNameField:nil
                            andValueField:valueField
                            andScopeField:nil];
}

- (IBAction)scopeUpdated:(id)sender {
  assert([sender isKindOfClass:[UISegmentedControl class]]);
  UISegmentedControl *scopeField = (UISegmentedControl *)sender;
  [self updateCustomVariableWithNameField:nil
                            andValueField:nil
                            andScopeField:scopeField];
}

- (IBAction)backgroundButtonClicked:(id)sender {
  assert(sender == backgroundButton_);
  [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
  [textField resignFirstResponder];
  return NO;
}

- (void)updateCustomVariableWithNameField:(UITextField *)nameField
                            andValueField:(UITextField *)valueField
                            andScopeField:(UISegmentedControl *)scopeField {
  int index;
  if (nameField != nil) {
    index =
        (nameField == var1Name_) ? 1 : (nameField == var2Name_) ? 2 :
        (nameField == var3Name_) ? 3 : (nameField == var4Name_) ? 4 :
        (nameField == var5Name_) ? 5 : 0;
  } else if (valueField != nil) {
    index =
        (valueField == var1Value_) ? 1 : (valueField == var2Value_) ? 2 :
        (valueField == var3Value_) ? 3 : (valueField == var4Value_) ? 4 :
        (valueField == var5Value_) ? 5 : 0;
  } else {
    assert(scopeField != nil);
    index =
        (scopeField == var1Scope_) ? 1 : (scopeField == var2Scope_) ? 2 :
        (scopeField == var3Scope_) ? 3 : (scopeField == var4Scope_) ? 4 :
        (scopeField == var5Scope_) ? 5 : 0;
  }
  assert(index != 0);
  if (nameField == nil) {
    nameField =
        (index == 1) ? var1Name_ : (index == 2) ? var2Name_ :
        (index == 3) ? var3Name_ : (index == 4) ? var4Name_ : var5Name_;
  }
  if (valueField == nil) {
    valueField =
        (index == 1) ? var1Value_ : (index == 2) ? var2Value_ :
        (index == 3) ? var3Value_ : (index == 4) ? var4Value_ : var5Value_;
  }
  if (scopeField == nil) {
    scopeField =
        (index == 1) ? var1Scope_ : (index == 2) ? var2Scope_ :
        (index == 3) ? var3Scope_ : (index == 4) ? var4Scope_ : var5Scope_;
  }
  GANCVScope scope =
      (scopeField.selectedSegmentIndex == 0) ? kGANVisitorScope :
      (scopeField.selectedSegmentIndex == 1) ? kGANSessionScope : kGANPageScope;
  NSLog(@"CV Index: %d", index);
  NSLog(@"CV  Name: '%@'", nameField.text);
  NSLog(@"CV Value: '%@'", valueField.text);
  NSLog(@"CV Scope: %@", scope == kGANVisitorScope ? @"Visitor" :
        scope == kGANSessionScope ? @"Session" : @"Page");

  NSError *error = nil;
  if (![[GANTracker sharedTracker] setCustomVariableAtIndex:index
                                                       name:nameField.text
                                                      value:valueField.text
                                                      scope:scope
                                                  withError:&error]) {
    [AlertDialog alertWithTitle:@"Custom Variable Error"
                     andMessage:[TrackerUtil trackerErrorString:error]
                   dismissAfter:kDefaultErrorDismissDelay];
  }
}

@end
