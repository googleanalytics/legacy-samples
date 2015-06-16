// Copyright 2011 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package com.google.android.apps.analytics.examples.mobileplayground;

import com.google.android.apps.analytics.examples.mobileplayground.MobilePlayground.UserInputException;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.Toast;

public class CustomVarActivity extends Activity {

  private static final int MIN_INDEX = 1;
  private static final int MAX_INDEX = 5;
  private static final int VISITOR_SCOPE = 1;
  private static final int SESSION_SCOPE = 2;
  private static final int PAGE_SCOPE = 3;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.customvar);

    setupCustomVar(R.id.customVarVisitor, R.string.customVarVisitorIndex,
        R.string.customVarVisitorName, R.string.customVarVisitorValue, VISITOR_SCOPE);
    setupCustomVar(R.id.customVarSession, R.string.customVarSessionIndex,
        R.string.customVarSessionName, R.string.customVarSessionValue, SESSION_SCOPE);
    setupCustomVar(R.id.customVarPage, R.string.customVarPageIndex,
        R.string.customVarPageName, R.string.customVarPageValue, PAGE_SCOPE);

    final Button setButton = (Button) findViewById(R.id.customVarSet);
    setButton.setOnClickListener(new OnClickListener() {
      @Override
      public void onClick(View v) {
        setCustomCustomVar();
      }
    });
  }

  @Override
  public void onResume() {
    super.onResume();

    // Disable buttons until tracker is set
    boolean enabled = MobilePlayground.isTrackerSet();
    LinearLayout group = (LinearLayout) findViewById(R.id.customVarGroup);
    for (int i = 0; i < group.getChildCount(); ++i) {
      if (group.getChildAt(i) instanceof Button) {
        group.getChildAt(i).setEnabled(enabled);
      }
    }
  }

  private void setCustomCustomVar() {
    try {
      if (!isCustomVarScopeSet()) {
        MobilePlayground.getTracker().setCustomVar(
            getCustomVarIndex(),
            getCustomVarName(),
            getCustomVarValue());
      } else {
        MobilePlayground.getTracker().setCustomVar(
            getCustomVarIndex(),
            getCustomVarName(),
            getCustomVarValue(),
            getCustomVarScope());
      }
    } catch (UserInputException e) {
      Toast.makeText(this, e.getMessage(), Toast.LENGTH_SHORT).show();
    }
  }

  private void setupCustomVar(int buttonId, final int indexId, final int nameId, final int valueId,
      final int scope) {
    final Button setButton = (Button) findViewById(buttonId);
    setButton.setOnClickListener(new OnClickListener() {
      @Override
      public void onClick(View v) {
        MobilePlayground.getTracker().setCustomVar(
            Integer.valueOf(getString(indexId)),
            getString(nameId),
            getString(valueId),
            scope);
      }
    });
  }

  private int getCustomVarIndex() throws UserInputException {
    String indexString = ((EditText) findViewById(R.id.customVarIndex)).getText().toString().trim();
    if (indexString.length() == 0) {
      throw new UserInputException(getString(R.string.customVarIndexWarning));
    } else {
      int index = Integer.valueOf(indexString);
      if (index < MIN_INDEX || index > MAX_INDEX) {
        throw new UserInputException(getString(R.string.customVarIndexWarning));
      }
      return index;
    }
  }

  private String getCustomVarName() throws UserInputException {
    String name = ((EditText) findViewById(R.id.customVarName)).getText().toString().trim();
    if (name.length() == 0) {
      throw new UserInputException(getString(R.string.customVarNameWarning));
    }
    return name;
  }

  private String getCustomVarValue() throws UserInputException {
    String value = ((EditText) findViewById(R.id.customVarValue)).getText().toString().trim();
    if (value.length() == 0) {
      throw new UserInputException(getString(R.string.customVarValueWarning));
    }
    return value;
  }

  private boolean isCustomVarScopeSet() {
    String scope = ((EditText) findViewById(R.id.customVarScope)).getText().toString().trim();
    return scope.length() > 0;
  }

  private int getCustomVarScope() throws UserInputException {
    if (!isCustomVarScopeSet()) {
      throw new UserInputException(getString(R.string.customVarScopeWarning));
    }
    int scope = Integer.valueOf(
        ((EditText) findViewById(R.id.customVarScope)).getText().toString().trim());
    if (scope != VISITOR_SCOPE && scope != SESSION_SCOPE && scope != PAGE_SCOPE) {
      throw new UserInputException(getString(R.string.customVarScopeWarning));
    }
    return scope;
  }
}
