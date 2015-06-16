// Copyright 2012 Google Inc. All Rights Reserved.
/**
 * @fileoverview A javascript library to enable tracking of user activity in an
 * Android WebView implemented in an Activty using a native Android Google
 * Analytics implementation using v2.0 or higher of the Google Analytics SDK
 * for Android.
 *
 * This library was designed with the following goals in mind:
 *
 *    1. Easy implementation. This library only requires the addition of
 *       one line of Javascript at the top of your existing ga.js
 *       implementation, as in this example:
 *
 *          _gaq.push(enableNativeTracking({name: "AndroidTracker"});
 *          _gaq.push(['_setAccount', 'UA-XXXX-Y']);
 *          _gaq.push(['_trackPageview']);
 *
 *    2. Easy to support new tracking features. As new features roll out for
 *       the Google Analytics SDK for Android, you will only need to update
 *       this javascript file to enable support. No modifications to Java are
 *       are necessary.
 *
 * This library has the following requirements and limitations:
 *
 *   1. The library relies on the Android application being tracked to use
 *      be able to use WebView.addJavascriptInterface responsibly. See
 *      http://developer.android.com/reference/android/webkit/WebView.html
 *
 *   2. The library depends on a Java wrapper class to handle mapping the core
 *      javacript tracking methods to the tracking methods used by the Google
 *      Analytics SDK for Android. This wrapper class helps make eCommerce
 *      tracking work. A working example of a wrapper class,
 *      AndroidJSInterface.java, has been provided in this package.
 *
 *   3. Currently this library requires v2.0 or higher of the Google Analytics
 *      SDK for Android. However, it could be easily adapted to support
 *      v1.x as well.
 *
 *   4. This library does not currently support multiple trackers in your web
 *      content or implemented natively in your app. If your web content uses
 *      multiple trackers, using this library will cause overcounting in your
 *      native app profiles. If your app uses mutiple trackers, this library
 *      only expects to use the default tracker.
 *
 * @author awales@google.com (Andrew Wales)
 */


/**
 * Pushing this function to the _gaq queue overrides the core tracking functions
 * to use the Android native tracker, when available.
 * @param {Object} options Configuration options for the library. Supported
 *     options include:
 *         name - the name of the Andriod JS interface. This is the name
 *                you provided addJavascriptInterface in your Java code.
 *
 * @return {Object} returns a closure containing core tracking function
 *     overrides.
 */
var enableNativeTracking = function(options) {
   return function() {

     // If native interface is not available, assume the user is viewing
     // on desktop or mobile web, and dont override the standard ga.js
     // definitions.
     if (typeof window[options.name] == 'undefined') {
       return;
     }

     var nativeInterface = window[options.name];

     // This library does not currently support multiple trackers.
     var t = _gat._getTrackerByName();

     /**
      * Initializes an Android native tracker object using the specified
      * property ID.
      * @param {string} propertyId Your Google Analytics property Id.
      */
     t._setAccount = function(propertyId) {
       nativeInterface.setProperty(propertyId);
     };


     /**
      * Tracks a screen view.
      * @param {string} screen The name of the screen being tracked.
      *     Does not include query string. Optional.
      */
     t._trackPageview = function(screen) {
       screen = screen || document.location.pathname;
       nativeInterface.getTracker().trackView(screen);
     };


     /**
      * Tracks an event.
      * @param {string} category The event category.
      * @param {string} action The event action.
      * @param {string} label The event label. Optional.
      * @param {number} value The event value. Optional.
      */
     t._trackEvent = function(category, action, label, value) {
       label = label || '';
       value = value || 0;

       nativeInterface.getTracker().trackEvent(category, action, label, value);
     };


     /**
      * Builds a transaction. This assumes the existence of a method in the
      * native interface called buildTrans that will store the transaction
      * in memory until it is dispatched.
      *
      * Note that currency values are multiplied by 1M here because
      * the GA Android SDK requries currency values to be in micros.
      *
      * @param {string} orderId The id of the transaction. Should be unique.
      * @param {string} affiliation The transaction affiliation.
      * @param {number} total Total transaction revenue (including tax and
            shipping, not in micros).
      * @param {number} tax The total tax (not in micros).
      * @param {number} shipping The total shipping (not in micros).
      */
     t._addTrans = function(orderId, affiliation, total, tax, shipping) {
       orderId = orderId || '';
       affiliation = affiliation || '';
       total = total * 1000000 || 0;
       tax = tax * 1000000 || 0;
       shipping = shipping * 1000000 || 0;

       pendingTrans = nativeInterface.buildTrans(orderId, total, affiliation,
           tax, shipping);
     };


     /**
      * Adds an item to a pending ecommerce transaction. This assumes
      * that the native interface is storing the pending ecommerce
      * transaction, and that a method called addItem exists to
      * append this item to that transaction.
      *
      * Note that currency values are multiplied by 1M here because
      * the GA Android SDK requries currency values to be in micros.
      *
      * @param {string} sku The sku of the item.
      * @param {string} name The name of the item.
      * @param {string} category The category of the item.
      * @param {number} price The price of the item.
      * @param {number} qty The quantity being purchased.
      */
     t._addItem = function(sku, name, category, price, qty) {
       sku = sku || '';
       name = name || '';
       category = category || '';
       price = price * 1000000 || 0;
       qty = qty || 0;

       nativeInterface.addItem(sku, price, name, qty, category);
     };


     /**
      * Tracks a pending transaction. Assumes that pending transaction
      * is being held in memory in by native interface.
      */
     t._trackTrans = function() {
       nativeInterface.trackTrans();
     };


     /**
      * Tracks a social interaction.
      * @param {string} network The related social network.
      * @param {string} action The social action being taken.
      * @param {string} target The target content of the social action.
            Optional.
      */
     t._trackSocial = function(network, action, target) {
       target = target || '';
       nativeInterface.getTracker().trackSocial(network, action, target);
     };


     /**
      * Tracks a user timing.
      * @param {string} category The category of the timing.
      * @param {number} interval The timing interval.
      * @param {string} name The name of the timing. Optional.
      * @param {string} label The timing label. Optional.
      */
     t._trackTiming = function(category, interval, name, label) {
       name = name || '';
       label = label || '';
       nativeInterface.getTracker().trackTiming(category, interval, name,
           label);
     };
   }
};
