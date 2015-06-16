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

import com.google.android.apps.analytics.easytracking.ParameterLoader;

import java.util.HashMap;
import java.util.Map;

/**
 * Mock class that implements the ParameterLoader interface.  This class
 * provides methods for seeding parameters as well as the methods defined in
 * the interface.  Used for testing the EasyTracker class.
 */
public class MockParameterLoader implements ParameterLoader {

  Map<String, String>strings = new HashMap<String, String>();
  Map<String, Boolean>bools = new HashMap<String, Boolean>();
  Map<String, Integer>ints = new HashMap<String, Integer>();
  
  public void addStringParameter(String key, String value) {
    strings.put(key, value);
  }
  
  public void addBooleanParameter(String key, boolean value) {
    bools.put(key, value);
  }
  
  public void addIntegerParameter(String key, int value) {
    ints.put(key, value);
  }

  @Override
  public String getString(String key) {
    return strings.get(key);
  }

  @Override
  public boolean getBoolean(String key) {
    if (bools.containsKey(key)) {
      return bools.get(key);
    }
    return false;
  }

  @Override
  public int getInt(String key, int defaultValue) {
    if (ints.containsKey(key)) {
      return ints.get(key);
    }
    return defaultValue;
  }

}
