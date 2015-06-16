// Copyright 2011 Google Inc. All Rights Reserved.

package com.campaigntracking.app;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.TextView;

/**
 * An application to test Android Market referral broadcasts for Android
 * applications using the Google Analytics Android SDK.
 *
 * To use Campaign Tracking Tool, run the application you'd like to test with
 * debug and dryRun flags set. While that application is running, run
 * the Campaign Tracking Tool and input a sample Android Market destination
 * URL that would be used in an ad.
 * 
 * Press "Send" to simulate the Market broadcast. Check the LogCat output under
 * log tag "GoogleAnalyticsTracker" to confirm that the referral information 
 * was received and stored by the target application.
 *
 * @author awales (Andrew Wales)
 */
public class CampaignTrackingActivity extends Activity  {

  private Button submitBtn;
  private CheckBox autoTagCheckbox;
  private Intent referrerIntent;
  private Log log;
  private Market testMarket;
  private TextView queryStringField;
  private TextView debugLog;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
      setContentView(R.layout.main);

    submitBtn = (Button) findViewById(R.id.submitButton);
    submitBtn.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(View v) {
        log.clearLog();
        processInput();
      }
    });

    queryStringField = (TextView) findViewById(R.id.queryStringField);
    debugLog = (TextView) findViewById(R.id.debugTextView);

    // Initialize a log object that will handle printing errors to screen.
    log = new Log(this.getApplicationContext(), debugLog);

    // Initialize a Market object for testing.
    testMarket = new Market(log);

    // Find and store reference to autoTagging Checkbox
    autoTagCheckbox = (CheckBox) findViewById(R.id.autoTagCheckbox);
  }


  /**
   * A method to get query string input and auto-tagging preference,
   * pass to Market, and then send broadcast.
   */
  public void processInput() {

    QueryString q = new QueryString(getUserInput());

    // If user is testing auto-tagging, add an auto-tagging parameter to
    // the query string.
    if (autoTagCheckbox.isChecked()) {
      q.addAutoTag();
    }

    // Test the query string for warnings and errors.
    testMarket.testQueryString(q);

    referrerIntent = testMarket.getReferrerIntent(q);
    broadcastIntent(referrerIntent);
  }


  public String getUserInput() {

    // Get user input from URL and package fields.
    return queryStringField.getText().toString();
  }


  public void broadcastIntent(Intent referrerIntent) {

    // Broadcast the intent returned by the Market class.
    if (referrerIntent.getComponent() != null) {
      sendBroadcast(referrerIntent);
      log.print(getString(R.string.broadcastSentMsg));

      // Print the details of the broadcast to the screen.
      log.print("\n");
      log.print("Intent details:");
      log.print("--------------");
      log.print(">> Broadcast to: " +
          referrerIntent.getComponent().toString());
      log.print(">> Referrer: " + referrerIntent.getStringExtra("referrer"));
    } else {
      log.print(getString(R.string.errorNoComponent));
    }
  }
}
