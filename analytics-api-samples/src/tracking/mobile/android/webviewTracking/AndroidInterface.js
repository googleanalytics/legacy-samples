// Copyright 2012 Google Inc. All Rights Reserved.

import com.google.analytics.tracking.android.GoogleAnalytics;
import com.google.analytics.tracking.android.Item;
import com.google.analytics.tracking.android.Tracker;
import com.google.analytics.tracking.android.Transaction;

import android.content.Context;

/**
 * This class is used as an interface between the nativeInterface.js library
 * running in a WebView, and a native Google Analytics Android implementation
 * running version 2 or higher of the SDK.
 *
 * To use this class with nativeInterface.js:
 *   1. Include this class in your app's package.
 *   2. Call addJavascriptInterface on each of your WebViews, passing an
 *      instance of AndroidJSInterface as an argument. For example:
 *
 *            mWebView.addJavascriptInterface(new AndroidJSInterface(this),
 *                 "AndroidJSInterface");
 *
 * @author awales@google.com (Andrew Wales)
 */
public class AndroidJSInterface {

  private GoogleAnalytics mInstance;
  private Tracker mTracker;
  private Transaction mPendingTrans = null;

  /**
   * Creates a new {@code AndroidJSInterface}
   * @param {Context} ctx Your app's application context.
   */
   AndroidJSInterface(Context ctx) {
     mInstance = GoogleAnalytics.getInstance(ctx.getApplicationContext());
     mTracker = mInstance.getDefaultTracker();
   }

  /**
   * Returns your app's default tracker.
   * @return Tracker your app's default tracker.
   */
  public Tracker getTracker() {
    return mTracker;
  }

  /**
   * Builds a transaction and stores it in a member field.
   * @param {String} transId The transaction ID. Should be unique.
   * @param {long} total The total transaction revenue (incl. tax, shipping
   * @param {String} affiliation The transaction affiliation.
   * @param {long} tax The total transaction tax.
   * @param {long} shipping The total shipping cost.
   */
  public void buildTrans(String transId, long total,
      String affiliation, long tax, long shipping) {
    mPendingTrans = new Transaction.Builder(
        transId,
        total)
        .setAffiliation(affiliation)
        .setTotalTaxInMicros(tax)
        .setShippingCostInMicros(shipping)
        .build();
  }

  /**
   * Adds an item to a pending transaction. If no transaction is pending,
   * the method returns;
   * @param {String} sku The product sku.
   * @param {long} price The product price.
   * @param {String} name The name of the product.
   * @param {long} qty The quantity of this product being sold.
   * @param {long} category The product category.
   */
  public void addItem(String sku, long price,
      String name, long qty, String category) {
    if (mPendingTrans == null) {
      return;
    }

    mPendingTrans.addItem(new Item.Builder(
        sku,
        name,
        price,
        qty)
        .setProductCategory(category)
        .build());
    }

  /**
   * Tracks a transaction, if one is pending.
   */
  public void trackTrans() {
    if (mPendingTrans != null) {
      mTracker.trackTransaction(mPendingTrans);
      mPendingTrans = null;
    }
  }
}
