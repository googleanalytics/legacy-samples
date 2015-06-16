// Copyright 2011 Google Inc. All Rights Reserved.

package com.campaigntracking.app;

import android.content.ComponentName;
import android.content.Intent;

import java.util.ArrayList;

/**
 * A class to simulate the Android Market for the purposes of testing Android
 * Market referral tracking.
 * 
 * @author awales (Andrew Wales)
 */
public class Market {

  private static final String GA_RECEIVER_CLASS =
      "com.google.android.apps.analytics.AnalyticsReceiver";
  private static final String [] UTM_TAGS = {"utm_source", "utm_medium", 
      "utm_campaign", "utm_content", "utm_term"};
  private static final String REFERRER_KEY = "referrer";
  private static final String PACKAGE_KEY = "id";
  private static final String INSTALL_ACTION =
      "com.android.vending.INSTALL_REFERRER";

  private Log log;


  /**
   * An object representing the properties and logic of the Android Market for
   * the purposes of testing referral tracking. A Market object takes a log 
   * object so that it can print output to that log.
   * 
   * @param l The log object to which the Market should print its output.
   */
  public Market(Log l) {

    log = l;
  }


  /**
   * A method to test a given query string for errors.
   * 
   * @param q The QueryString object to be tested.
   */
  public void testQueryString(QueryString q) {

    // If the query string contains no parameters, print an error.
    if (!q.hasParameters()) {
      log.print(R.string.errorNoParams);
    }

    // If the query string has no id parameter specifying the application's
    // package, print an error.
    if (!q.hasId()) {
      log.print(R.string.errorNoId);
    }

    // If the query string has a referrer parameter,
    if (q.hasReferrer(REFERRER_KEY)) {
      // print an error if the the value is not encoded.
      if (!q.isEncoded(REFERRER_KEY)) {
        log.print(R.string.errorNotEncoded);
      }
    } // Otherwise, log a warning if query string has no referrer parameter.
    log.print(R.string.warningNoReferrer);

    // If the query string contains 'utm' tags outside of the referrer
    // parameter, print a warning and include the floating utm tags identified.
    ArrayList <String> floatingTags = q.getFloatingUtmTags(UTM_TAGS);
    if (floatingTags.size() > 0) {
      log.print(R.string.warningFloatingTags);
      for (int x = 0; x < floatingTags.size(); x++)  {
        log.print(floatingTags.get(x));
      }
    }
  }


  /**
   * A method to build a component name given a package name
   * and Google Analytics Receiver class.
   * 
   * @return {@code null} when id parameter is not present in
   * parameter (@code Map}.
   */
  public ComponentName getComponentName(QueryString q) {

    if (q.hasId()) {
      return new ComponentName(q.getPackageName(PACKAGE_KEY),
          GA_RECEIVER_CLASS);
    }
    return null;
  }


  /**
   * A method to initialize and return the Intent that will be used 
   * in the Market's INSTALL_REFERRER broadcast.
   * 
   * @return install_referrer intent to be used in broadcast.
   */
  public Intent getReferrerIntent(QueryString q) {

    Intent referrerIntent = new Intent();

    referrerIntent.setAction(INSTALL_ACTION);
    referrerIntent.setComponent(getComponentName(q));
    referrerIntent.putExtra(REFERRER_KEY, q.getReferrer(REFERRER_KEY));

    return referrerIntent;
    }
}
