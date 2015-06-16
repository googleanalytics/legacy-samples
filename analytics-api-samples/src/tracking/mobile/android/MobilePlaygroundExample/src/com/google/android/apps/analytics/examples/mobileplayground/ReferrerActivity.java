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

public class ReferrerActivity extends Activity {

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.referrer);

    final Button gclidReferrerButton = (Button) findViewById(R.id.gclidReferrer);
    gclidReferrerButton.setOnClickListener(new OnClickListener() {
      @Override
      public void onClick(View v) {
        setGclidReferrer();
      }
    });

    final Button utmReferrerButton = (Button) findViewById(R.id.utmReferrer);
    utmReferrerButton.setOnClickListener(new OnClickListener() {
      @Override
      public void onClick(View v) {
        setUtmReferrer();
      }
    });
  }

  @Override
  public void onResume() {
    super.onResume();

    // Disable buttons until tracker is set
    boolean enabled = MobilePlayground.isTrackerSet();
    LinearLayout group = (LinearLayout) findViewById(R.id.referrerGroup);
    for (int i = 0; i < group.getChildCount(); ++i) {
      if (group.getChildAt(i) instanceof Button) {
        group.getChildAt(i).setEnabled(enabled);
      }
    }
  }

  private void setGclidReferrer() {
    try {
      String referrer = "gclid=" + getGclid();
      MobilePlayground.getTracker().setReferrer(referrer);
    } catch (UserInputException e) {
      Toast.makeText(this, e.getMessage(), Toast.LENGTH_SHORT).show();
    }
  }

  private void setUtmReferrer() {
    try {
      StringBuffer referrer = new StringBuffer();
      referrer.append("utm_campaign=").append(getUtmCampaign());
      referrer.append("&utm_medium=").append(getUtmMedium());
      referrer.append("&utm_source=").append(getUtmSource());
      String optUtmTerm = getOptUtmTerm();
      if (optUtmTerm != null) {
        referrer.append("&utm_term=").append(getOptUtmTerm());
      }
      String optUtmContent = getOptUtmContent();
      if (optUtmContent != null) {
        referrer.append("&utm_source=").append(getOptUtmContent());
      }
      MobilePlayground.getTracker().setReferrer(referrer.toString());
    } catch (UserInputException e) {
      Toast.makeText(this, e.getMessage(), Toast.LENGTH_SHORT).show();
    }
  }

  private String getGclid() throws UserInputException {
    String event = ((EditText) findViewById(R.id.gclid)).getText().toString().trim();
    if (event.length() == 0) {
      throw new UserInputException(getString(R.string.gclidWarning));
    }
    return event;
  }

  private String getUtmCampaign() throws UserInputException {
    String event = ((EditText) findViewById(R.id.utmCampaign)).getText().toString().trim();
    if (event.length() == 0) {
      throw new UserInputException(getString(R.string.utmCampaignWarning));
    }
    return event;
  }

  private String getUtmMedium() throws UserInputException {
    String event = ((EditText) findViewById(R.id.utmMedium)).getText().toString().trim();
    if (event.length() == 0) {
      throw new UserInputException(getString(R.string.utmMediumWarning));
    }
    return event;
  }

  private String getUtmSource() throws UserInputException {
    String event = ((EditText) findViewById(R.id.utmSource)).getText().toString().trim();
    if (event.length() == 0) {
      throw new UserInputException(getString(R.string.utmSourceWarning));
    }
    return event;
  }

  private String getOptUtmTerm() {
    String event = ((EditText) findViewById(R.id.utmTerm)).getText().toString().trim();
    if (event.length() == 0) {
      return null;
    }
    return event;
  }

  private String getOptUtmContent() {
    String event = ((EditText) findViewById(R.id.utmContent)).getText().toString().trim();
    if (event.length() == 0) {
      return null;
    }
    return event;
  }
}
