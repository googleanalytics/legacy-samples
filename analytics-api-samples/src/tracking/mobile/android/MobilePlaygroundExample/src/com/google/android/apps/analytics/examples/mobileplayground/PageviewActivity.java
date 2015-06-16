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

public class PageviewActivity extends Activity {

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.pageview);

    setupPageview(R.id.homePageview, R.string.homePath);
    setupPageview(R.id.helpPageview, R.string.helpPath);
    setupPageview(R.id.level1Pageview, R.string.level1Path);
    setupPageview(R.id.level2Pageview, R.string.level2Path);

    final Button sendButton = (Button) findViewById(R.id.pageviewSend);
    sendButton.setOnClickListener(new OnClickListener() {
      @Override
      public void onClick(View v) {
        sendCustomPageview();
      }
    });

    final Button dispatchButton = (Button) findViewById(R.id.pageviewDispatch);
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
    LinearLayout group = (LinearLayout) findViewById(R.id.pageviewGroup);
    for (int i = 0; i < group.getChildCount(); ++i) {
      if (group.getChildAt(i) instanceof Button) {
        group.getChildAt(i).setEnabled(enabled);
      }
    }
  }

  private void sendCustomPageview() {
    try {
      MobilePlayground.getTracker().trackPageView(getCustomPath());
    } catch (UserInputException e) {
      Toast.makeText(this, e.getMessage(), Toast.LENGTH_SHORT).show();
    }
  }

  private void setupPageview(int buttonId, int pathId) {
    final Button pageviewButton = (Button) findViewById(buttonId);
    // Set button text
    final String path = getString(pathId);
    final String sendText = getString(R.string.sendPrefix) + path;
    pageviewButton.setText(sendText);
    // Set listener to track a pageview.
    pageviewButton.setOnClickListener(new OnClickListener() {
      @Override
      public void onClick(View v) {
        MobilePlayground.getTracker().trackPageView(path);
      }
    });
  }

  private String getCustomPath() throws UserInputException {
    String path = ((EditText) findViewById(R.id.path)).getText().toString().trim();
    if (path.length() == 0) {
      throw new UserInputException(getString(R.string.pathWarning));
    }
    return path;
  }
}
