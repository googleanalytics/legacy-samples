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

import android.app.TabActivity;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.widget.TabHost;

public class MobilePlayground extends TabActivity {

  /**
   * Represents user input error as an exception
   */
  public static class UserInputException extends Exception {
    public UserInputException(String message) {
      super(message);
    }
  }

  private static GoogleAnalyticsTracker tracker;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.main);
    setupDisplay();
  }

  @Override
  protected void onDestroy() {
    super.onDestroy();

    // Stop the tracker when the application is done.
    if (tracker != null) {
      tracker.stopSession();
    }
  }

  private void setupDisplay() {
    Resources resources = getResources(); // Resource object to get Drawables
    TabHost tabHost = getTabHost(); // The activity TabHost

    setTab(resources, tabHost, SettingsActivity.class, R.string.settingsTabName);
    setTab(resources, tabHost, ReferrerActivity.class, R.string.referrerTabName);
    setTab(resources, tabHost, PageviewActivity.class, R.string.pageviewTabName);
    setTab(resources, tabHost, EventActivity.class, R.string.eventTabName);
    setTab(resources, tabHost, CustomVarActivity.class, R.string.customVarTabName);
    setTab(resources, tabHost, EcommerceActivity.class, R.string.ecommerceTabName);
  }

  private void setTab(Resources resources, TabHost tabHost, Class<?> activity, int tabNameId) {
    // Create an Intent to launch an Activity for the tab
    Intent intent = new Intent().setClass(this, activity);

    // Initialize a TabSpec for each tab and add it to the TabHost
    String tabName = getString(tabNameId);
    TabHost.TabSpec tabSpec = tabHost.newTabSpec(tabName)
        .setIndicator(tabName, resources.getDrawable(R.drawable.tab))
        .setContent(intent);
    tabHost.addTab(tabSpec);
  }

  static boolean isTrackerSet() {
    return tracker != null;
  }

  static GoogleAnalyticsTracker getTracker() {
    return tracker;
  }

  static GoogleAnalyticsTracker createTracker() {
    tracker = GoogleAnalyticsTracker.getInstance();
    return tracker;
  }
}
