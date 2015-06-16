// Copyright 2011 Google Inc. All Rights Reserved.

package com.example.android.notepad;

import com.google.android.apps.analytics.GoogleAnalyticsTracker;

import android.app.Activity;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.res.Configuration;
import android.os.Bundle;

/**
 * This class adds simple pageview tracking to any class that extends it.  It
 * uses the automatic dispatch interval of 1 second to dispatch pending hits.
 * It also turns on debug and dryRun flags.
 */
public class TrackedActivity extends Activity {

    private static final int VISITOR_SCOPE = 1;
    private static final int SESSION_SCOPE = 2;
    private static final int PAGE_SCOPE = 3;

    private static final int CV_SCREEN_ORIENTATION_SLOT = 1;

    GoogleAnalyticsTracker tracker;

    // onCreate is called then the Activity is created.  We'll create the
    // tracker here and set it up with the appropriate flags, account id and
    // start it up.
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        tracker = GoogleAnalyticsTracker.getInstance();
        tracker.setDebug(true);
        tracker.setDryRun(true);
        tracker.start(getString(R.string.ga_api_key), 1, getApplicationContext());

        // Determine the screen orientation and set it in a custom variable.
        String orientation = "unknown";
        switch (getResources().getConfiguration().orientation) {
            case Configuration.ORIENTATION_LANDSCAPE:
                orientation = "landscape";
                break;
            case Configuration.ORIENTATION_PORTRAIT:
                orientation = "portrait";
                break;
        }
        tracker.setCustomVar(CV_SCREEN_ORIENTATION_SLOT,  // Slot
                             "Screen Orientation",        // Name
                             orientation,                 // Value
                             SESSION_SCOPE);              // Scope

    }

    @Override
    protected void onResume() {
        super.onResume();

        // We want to track a pageView every time this Activity gets the focus.
        tracker.trackPageView("/" + this.getLocalClassName());
    }
}
