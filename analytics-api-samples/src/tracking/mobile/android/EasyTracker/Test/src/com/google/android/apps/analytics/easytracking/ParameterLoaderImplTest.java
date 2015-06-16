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

import com.google.android.apps.analytics.easytracking.ParameterLoaderImpl;

import android.test.AndroidTestCase;

/**
 * Tests for the ParameterLoaderImpl class.
 */
public class ParameterLoaderImplTest extends AndroidTestCase {

  ParameterLoaderImpl gapi;
  
  @Override
  protected void setUp() {
    gapi = new ParameterLoaderImpl(this.getContext());
  }

  public void testNoContext() {
    try {
      gapi = new ParameterLoaderImpl(null);
      fail("NullPointerException expected");
    } catch (NullPointerException expected) {
      // Expected result
    }
  }

  public void testString() {
    assertNull(gapi.getString("nullValue"));
    assertEquals("Hello World!", gapi.getString("hello"));
  }
  
  public void testBoolean() {
    assertTrue(gapi.getBoolean("boolTrue"));
    assertFalse(gapi.getBoolean("boolTrueString"));
    assertFalse(gapi.getBoolean("boolFalse"));
    assertFalse(gapi.getBoolean("boolUnknown"));
    assertFalse(gapi.getBoolean("boolMissing"));
  }
  
  public void testInt() {
    assertEquals(5, gapi.getInt("five", 10));
    assertEquals(0, gapi.getInt("zero", 10));
    assertEquals(10, gapi.getInt("ten", 10));
    assertEquals(10, gapi.getInt("npe", 10));
  }
}
