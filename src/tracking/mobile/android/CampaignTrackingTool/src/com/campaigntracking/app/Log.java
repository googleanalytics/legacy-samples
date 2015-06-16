// Copyright 2011 Google Inc. All Rights Reserved.

package com.campaigntracking.app;

import android.content.Context;
import android.widget.TextView;

/**
 * A class to represent a log that can be displayed on screen
 * to indicate the outcome of a test broadcast.
 * 
 * @author awales (Andrew Wales)
 */
public class Log extends TextView {

    private Context ctx;
    private TextView debugView;

    public Log(Context context, TextView debugRef) {
      super(context);
      ctx = context.getApplicationContext();
      debugView = debugRef;
    }


    public void print(int resId) {
      if (resId != 0) {
        debugView.append("\n" + ctx.getString(resId) + "\n");
      }
    }
    


    public void print(String msg) {
      if (msg != null) {
        debugView.append("\n" + msg);
      }
    }


    public void clearLog() {
      debugView.setText("");
    }
}
