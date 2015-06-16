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

import com.google.android.apps.analytics.GoogleAnalyticsTracker;
import com.google.android.apps.analytics.examples.mobileplayground.MobilePlayground.UserInputException;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;
import android.widget.ToggleButton;

public class SettingsActivity extends Activity {

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.settings);

    final EditText dispatchIntervalText = (EditText) findViewById(R.id.dispatchInterval);
    final ToggleButton autoDispatch = (ToggleButton) findViewById(R.id.autoDispatch);
    autoDispatch.toggle();
    autoDispatch.setOnClickListener(new OnClickListener() {
      @Override
      public void onClick(View v) {
        dispatchIntervalText.setEnabled(autoDispatch.isChecked());
      }
    });

    // TODO(aihawkins): Add handle for stop session.

    final Button startButton = (Button) findViewById(R.id.startSession);
    startButton.setOnClickListener(new OnClickListener() {
      @Override
      public void onClick(View v) {
        startSession();
      }
    });
  }

  private void startSession() {
    // Get and validate web property ID before creating the tracker
    String webPropertyId;
    try {
      webPropertyId = getWebPropertyId();
    } catch (UserInputException e) {
      Toast.makeText(this, e.getMessage(), Toast.LENGTH_SHORT).show();
      return;
    }

    // TODO(aihawkins): Every interaction with the tracker that might throw an exception should be
    // surrounded with try/catch

    // Create the tracker or stop the previous session
    GoogleAnalyticsTracker tracker;
    if (!MobilePlayground.isTrackerSet()) {
      tracker = MobilePlayground.createTracker();
    } else {
      tracker = MobilePlayground.getTracker();
      tracker.stopSession();
    }

    // Start the tracker. Note that it's acceptable to use any activity context.
    if (!isAutoDispatch()) {
      tracker.startNewSession(webPropertyId, this);
    } else {
      tracker.startNewSession(webPropertyId, getDispatchInterval(), this);
    }

    // Various additional options
    tracker.setAnonymizeIp(getAnonymizeIp());
    tracker.setDebug(getDebug());
    tracker.setDryRun(getDryRun());
  }

  private String getWebPropertyId() throws UserInputException {
    String id = ((EditText) findViewById(R.id.webPropertyId)).getText().toString().trim();
    if (id.length() == 0) {
      throw new UserInputException(getString(R.string.webPropertyIdWarning));
    }
    return id;
  }

  private boolean getAnonymizeIp() {
    return ((ToggleButton) findViewById(R.id.anonymizeIp)).isChecked();
  }

  private boolean isAutoDispatch() {
    return ((ToggleButton) findViewById(R.id.autoDispatch)).isChecked();
  }

  private Integer getDispatchInterval() {
    String intervalString = ((EditText) findViewById(R.id.dispatchInterval)).getText().toString();
    if (intervalString.length() == 0) {
      return setDefaultDispatchInterval();
    } else {
      int interval = Integer.valueOf(intervalString);
      if (interval == 0) {
        return setDefaultDispatchInterval();
      }
      return interval;
    }
  }

  private Integer setDefaultDispatchInterval() {
    Toast.makeText(this, R.string.dispatchIntervalWarning, Toast.LENGTH_SHORT).show();
    ((EditText) findViewById(R.id.dispatchInterval)).setText(R.string.dispatchInterval);
    return Integer.valueOf(getString(R.string.dispatchInterval));
  }

  private boolean getDebug() {
    return ((ToggleButton) findViewById(R.id.debug)).isChecked();
  }

  private boolean getDryRun() {
    return ((ToggleButton) findViewById(R.id.dryRun)).isChecked();
  }
}
