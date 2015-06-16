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

public class EventActivity extends Activity {

  private static final String NO_LABEL = null;
  private static final int NO_VALUE = -1;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.event);

    setupEvent(R.id.video1Play, R.string.videoCategory, R.string.videoPlay, R.string.video1);
    setupEvent(R.id.video1Pause, R.string.videoCategory, R.string.videoPause, R.string.video1);
    setupEvent(R.id.video2Play, R.string.videoCategory, R.string.videoPlay, R.string.video2);
    setupEvent(R.id.video2Pause, R.string.videoCategory, R.string.videoPause, R.string.video2);

    setupEvent(R.id.book1View, R.string.bookCategory, R.string.bookView, R.string.book1);
    setupEvent(R.id.book1Share, R.string.bookCategory, R.string.bookShare, R.string.book1);
    setupEvent(R.id.book2View, R.string.bookCategory, R.string.bookView, R.string.book2);
    setupEvent(R.id.book2Share, R.string.bookCategory, R.string.bookShare, R.string.book2);

    final Button sendButton = (Button) findViewById(R.id.eventSend);
    sendButton.setOnClickListener(new OnClickListener() {
      @Override
      public void onClick(View v) {
        sendCustomEvent();
      }
    });

    final Button dispatchButton = (Button) findViewById(R.id.eventDispatch);
    dispatchButton.setOnClickListener(new OnClickListener() {
      @Override
      public void onClick(View v) {
        // Manually start a dispatch (Unnecessary if the tracker has a dispatch interval)
        MobilePlayground.getTracker().dispatch();
      }
    });
  }

  @Override
  public void onResume() {
    super.onResume();

    // Disable buttons until tracker is set
    boolean enabled = MobilePlayground.isTrackerSet();
    LinearLayout group = (LinearLayout) findViewById(R.id.eventGroup);
    for (int i = 0; i < group.getChildCount(); ++i) {
      if (group.getChildAt(i) instanceof Button) {
        group.getChildAt(i).setEnabled(enabled);
      }
    }
  }

  private void sendCustomEvent() {
    try {
      MobilePlayground.getTracker().trackEvent(
          getEventCategory(),
          getEventAction(),
          getEventLabel(),
          getEventValue());
    } catch (UserInputException e) {
      Toast.makeText(this, e.getMessage(), Toast.LENGTH_SHORT).show();
    }
  }

  private void setupEvent(int buttonId, final int categoryId, final int actionId,
      final int labelId) {
    final Button pageviewButton = (Button) findViewById(buttonId);
    pageviewButton.setOnClickListener(new OnClickListener() {
      @Override
      public void onClick(View v) {
        MobilePlayground.getTracker().trackEvent(
            getString(categoryId),
            getString(actionId),
            getString(labelId),
            NO_VALUE);
      }
    });
  }

  private String getEventCategory() throws UserInputException {
    String event = ((EditText) findViewById(R.id.eventCategory)).getText().toString().trim();
    if (event.length() == 0) {
      throw new UserInputException(getString(R.string.eventCategoryWarning));
    }
    return event;
  }

  private String getEventAction() throws UserInputException {
    String action = ((EditText) findViewById(R.id.eventAction)).getText().toString().trim();
    if (action.length() == 0) {
      throw new UserInputException(getString(R.string.eventActionWarning));
    }
    return action;
  }

  private String getEventLabel() {
    String label = ((EditText) findViewById(R.id.eventLabel)).getText().toString().trim();
    if (label.length() == 0) {
      return NO_LABEL;
    }
    return label;
  }

  private int getEventValue() {
    String value = ((EditText) findViewById(R.id.eventValue)).getText().toString().trim();
    if (value.length() == 0) {
      return NO_VALUE;
    }
    return Integer.valueOf(value);
  }
}
