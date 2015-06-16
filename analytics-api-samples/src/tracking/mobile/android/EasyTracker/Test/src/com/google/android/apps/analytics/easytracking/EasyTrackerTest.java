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

import com.google.android.apps.analytics.easytracking.EasyTracker;

import android.app.Activity;
import android.test.AndroidTestCase;

/**
 * Tests for the EasyTracker class.
 */
public class EasyTrackerTest extends AndroidTestCase {

  EasyTracker tracker;
  MockParameterLoader parameterLoader;
  MockGoogleAnalyticsTracker mockGATracker;
  Activity mockActivity = new Activity();
  Activity mockActivity2 = new Activity();

  @Override
  protected void setUp() {
    tracker = EasyTracker.getTracker();
    parameterLoader = new MockParameterLoader();
    mockGATracker = new MockGoogleAnalyticsTracker();
  }

  private void setUpStandardParameters() {
    parameterLoader.addStringParameter("ga_api_key", "UA-12345-6");
    parameterLoader.addBooleanParameter("ga_debug", true);
    parameterLoader.addBooleanParameter("ga_dryRun", true);
    parameterLoader.addIntegerParameter("ga_sampleRate", 55);
    parameterLoader.addBooleanParameter("ga_anonymizeIp", false);
    parameterLoader.addIntegerParameter("ga_dispatchPeriod", 5);
    parameterLoader.addBooleanParameter("ga_auto_activity_tracking", true);
  }

  @Override
  protected void tearDown() {
    EasyTracker.clearTracker();
  }

  private void assertCallsMade(int startNewSession, int trackPageView, int trackEvent) {
    // We need to wait for the trackerThread to catch up.
    try { Thread.sleep(1000); } catch (InterruptedException e) {}
    assertEquals(startNewSession, mockGATracker.getNumberCallsMade("startNewSession"));
    assertEquals(trackPageView, mockGATracker.getNumberCallsMade("trackPageView"));
    assertEquals(trackEvent, mockGATracker.getNumberCallsMade("trackEvent"));
  }

  public void test_noTracking() {
    // Order is important here.
    tracker.setContext(this.getContext(), parameterLoader);
    tracker.setTrackerDelegate(mockGATracker);
    
    tracker.startNewSession();
    
    assertCallsMade(0, 0, 0);
  }

  public void testInitialization() {
    // Order is important here.
    setUpStandardParameters();
    tracker.setContext(this.getContext(), parameterLoader);
    tracker.setTrackerDelegate(mockGATracker);

    // Call this just to initialize stuff.
    tracker.startNewSession();

    assertCallsMade(1, 0, 0);

    // Validate the parameters now.
    assertTrue(mockGATracker.getDebug());
    assertTrue(mockGATracker.isDryRun());
    assertEquals(55, mockGATracker.getSampleRate());
    assertFalse(mockGATracker.getAnonymizeIp());  
    assertEquals("UA-12345-6", mockGATracker.getAccountId());
    assertEquals(5, mockGATracker.getDispatchPeriod());
  }
  
  public void test_autoActivityTracking() {
    // Order is important here.
    setUpStandardParameters();
    tracker.setContext(this.getContext(), parameterLoader);
    tracker.setTrackerDelegate(mockGATracker);

    tracker.trackActivityStart(mockActivity);
    tracker.trackActivityStart(mockActivity2);
    tracker.trackActivityStop(mockActivity);
    tracker.trackActivityStop(mockActivity2);

    assertCallsMade(1, 2, 1);
  }

  public void test_autoActivityTrackingOff() {
    // Order is important here.
    setUpStandardParameters();
    parameterLoader.addBooleanParameter("ga_auto_activity_tracking", false);
    
    tracker.setContext(this.getContext(), parameterLoader);
    tracker.setTrackerDelegate(mockGATracker);

    tracker.trackActivityStart(mockActivity);
    tracker.trackActivityStart(mockActivity2);
    tracker.trackActivityStop(mockActivity);
    tracker.trackActivityStop(mockActivity2);

    assertCallsMade(1, 0, 2);
  }

  public void testConfigChange_autoActivityTrackingOn() {
    // Order is important here.
    setUpStandardParameters();
    
    tracker.setContext(this.getContext(), parameterLoader);
    tracker.setTrackerDelegate(mockGATracker);

    tracker.trackActivityStart(mockActivity);
    tracker.trackActivityStop(mockActivity);
    tracker.trackActivityRetainNonConfigurationInstance();
    tracker.trackActivityStart(mockActivity);
    tracker.trackActivityStop(mockActivity);

    assertCallsMade(1, 2, 2);
  }

  public void testConfigChange_autoActivityTrackingOff() {
    // Order is important here.
    setUpStandardParameters();
    parameterLoader.addBooleanParameter("ga_auto_activity_tracking", false);
    
    tracker.setContext(this.getContext(), parameterLoader);
    tracker.setTrackerDelegate(mockGATracker);

    tracker.trackActivityStart(mockActivity);
    tracker.trackActivityStop(mockActivity);
    tracker.trackActivityRetainNonConfigurationInstance();
    tracker.trackActivityStart(mockActivity);
    tracker.trackActivityStop(mockActivity);

    assertCallsMade(1, 0, 3);
  }

  public void testTwoSessions_autoActivityTrackingOn() {
    // Order is important here.
    setUpStandardParameters();
    
    tracker.setContext(this.getContext(), parameterLoader);
    tracker.setTrackerDelegate(mockGATracker);

    tracker.trackActivityStart(mockActivity);
    tracker.trackActivityStop(mockActivity);
    tracker.trackActivityStart(mockActivity);
    tracker.trackActivityStop(mockActivity);

    assertCallsMade(2, 2, 2);
  }

  public void testTwoSessions_autoActivityTrackingOff() {
    // Order is important here.
    setUpStandardParameters();
    parameterLoader.addBooleanParameter("ga_auto_activity_tracking", false);
    
    tracker.setContext(this.getContext(), parameterLoader);
    tracker.setTrackerDelegate(mockGATracker);

    tracker.trackActivityStart(mockActivity);
    tracker.trackActivityStop(mockActivity);
    tracker.trackActivityStart(mockActivity);
    tracker.trackActivityStop(mockActivity);

    assertCallsMade(2, 0, 4);
  }
}
