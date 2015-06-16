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

package com.google.android.apps.analytics.easytracking;

import com.google.android.apps.analytics.Item;
import com.google.android.apps.analytics.Transaction;
import com.google.android.apps.analytics.easytracking.GoogleAnalyticsTrackerDelegate;

import android.content.Context;

import java.util.HashMap;
import java.util.Map;

/**
 * Mock of implementation of the GoogleAnalyticsTrackerDelegate interface used
 * for testing the EasyTracking library.  This Mock tracks the number of calls
 * made for each method that handles tracking and also retains the values of
 * parameters set (like debug or dryRun).  It provides getter methods to inspect
 * those parameters.  Used for testing the EasyTracker class.
 */
public class MockGoogleAnalyticsTracker implements GoogleAnalyticsTrackerDelegate {
  
  private boolean debug;
  private boolean dryRun;
  private int sampleRate;
  private boolean anonymizeIp;
  private int dispatchPeriod;
  private String accountId;
  private Map<String, Integer>callsMade = new HashMap<String, Integer>();

  public String getAccountId() {
    return this.accountId;
  }
  
  public int getDispatchPeriod() {
    return this.dispatchPeriod;
  }

  public Map<String, Integer> getCallsMade() {
    return callsMade;
  }

  /**
   * Returns the number of calls made for the method described by the input
   * parameter methodName.
   *
   * @param methodName
   * @return the number of calls made, or 0 if none.
   */
  public int getNumberCallsMade(String methodName) {
    if (callsMade.containsKey(methodName)) {
      return callsMade.get(methodName);
    } else {
      return 0;
    }
  }

  /**
   * Increment the number of calls made for the method described by the input
   * parameter callMade.
   *
   * @param callMade name of the method call
   */
  private void incrementCallsMade(String callMade) {
    int previousCalls = 0;
    if (callsMade.containsKey(callMade)) {
      previousCalls = callsMade.get(callMade);
    }
    callsMade.put(callMade, previousCalls + 1);
  }

  @Override
  public void startNewSession(String accountId, int dispatchPeriod, Context ctx) {
    incrementCallsMade("startNewSession");
    this.accountId = accountId;
    this.dispatchPeriod = dispatchPeriod;
  }

  @Override
  public void trackEvent(String category, String action, String label, int value) {
    incrementCallsMade("trackEvent");
  }

  @Override
  public void trackPageView(String pageUrl) {
    incrementCallsMade("trackPageView");
  }

  @Override
  public boolean dispatch() {
    incrementCallsMade("dispatch");
    return false;
  }

  @Override
  public void stopSession() {
    incrementCallsMade("stopSession");
  }

  @Override
  public boolean setCustomVar(int index, String name, String value, int scope) {
    // Not used
    return false;
  }

  @Override
  public boolean setCustomVar(int index, String name, String value) {
    // Not used
    return false;
  }

  @Override
  public void addTransaction(Transaction transaction) {
    // Not used
  }

  @Override
  public void addItem(Item item) {
    // Not used
  }

  @Override
  public void trackTransactions() {
    // Not used
    clearTransactions();
  }

  @Override
  public void clearTransactions() {
    // Not used
  }

  @Override
  public void setAnonymizeIp(boolean anonymizeIp) {
    this.anonymizeIp = anonymizeIp;
  }

  public boolean getAnonymizeIp() {
    return this.anonymizeIp;
  }

  @Override
  public void setSampleRate(int sampleRate) {
    this.sampleRate = sampleRate;
  }

  public int getSampleRate() {
    return this.sampleRate;
  }

  @Override
  public boolean setReferrer(String referrer) {
    // Not used
    return false;
  }

  @Override
  public void setDebug(boolean debug) {
    this.debug = debug;
  }

  public boolean getDebug() {
    return this.debug;
  }

  @Override
  public void setDryRun(boolean dryRun) {
    this.dryRun = dryRun;
  }

  public boolean isDryRun() {
    return this.dryRun;
  }

}
