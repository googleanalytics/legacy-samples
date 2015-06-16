// Copyright 2012 Google Inc. All Rights Reserved.

/* Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @fileoverview A nice little script demo-ing how to use the _trackTiming
 * feature in Google Analytics to track the time it takes to
 * load resources asynchrounously. This script defines the TrackTiming
 * class to abstract all the timing logic. You can reuse this class
 * in your own code to simplify tracking.
 * @author api.nickm@gmail.com (Nick Mihailovski)
 */


/**
 * URL of a file that will be loaded using an XML HttpRerquest object.
 * @type {String}
 */
var C_QUOTES = 'http://analytics-api-samples.googlecode.com/svn/trunk/src/tracking/javascript/v5/user-timing/quotes.txt';


/**
 * Demo 1.
 * Uses a DOM script object to asynchronously retrieve the JQuery library
 * hosted on both Google's and Microsoft's content delivery networks.
 * First the UI is cleared. Then each URL is appened with a random query
 * parameter to prevent browser caching. A new TrackTiming object is created
 * for each request and passed to the loadJS function to make the request.
 * Once complete the demo1callback method is called.
 */
function runDemo1() {

  document.getElementById('demo1Time').innerHTML = '';

  var url = cacheBust('//ajax.aspnetcdn.com/ajax/jQuery/jquery-1.7.1.min.js');
  var t1 = new TrackTiming('JavaScript Libraries', 'Load jQuery', 'MSFT CDN').debug();

  loadJs(url, demo1callback, t1);

  url = cacheBust('//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js');
  var t2 = new TrackTiming('JavaScript Libraries', 'Load jQuery', 'Goog CDN').debug();

  loadJs(url, demo1callback, t2);
}


/**
 * Asynchronously loads a JavaScript resources by creating a DOM Script
 * element and appending it to the page. The time it takes to load the
 * script is tracking using a TrackTiming object. Just before the script
 * element is added to the page, the TrackTiming timer is started. The
 * entire TrackTiming object is then set as a property on the script
 * object. And finally the script element is added to the DOM to force
 * the browser to load the script resource.
 * @param {String} url The URL of a JavaScript resource to load
 *     asynchronously.
 * @param {Function} callback The callback function to execute once the
 *     JavaScript resource has loaded.
 * @param {Object} tt The TrackTiming object used to track the time the
 *     browser takes to load the resource.
 */
function loadJs(url, callback, tt) {
  var js = document.createElement('script');
  js.async = true;
  js.src = url;
  js.onload = callback;
  var s = document.getElementsByTagName('script')[0];

  js.time = tt.startTime();

  s.parentNode.insertBefore(js, s);
}


/**
 * Callback function for demo 1. This will be executed once the JavaScript
 * resource is loaded from loadJs. The event object is the onload event
 * fired from the script element. So the event object is used to get a
 * reference to the script object as well as the TrackTiming object. Finally
 * the elapsed time is outputhed to the page.
 * @param {Object} event The onload event object that is fired once the
 *     script has loaded.
 */
function demo1callback(event) {
  var e = event || window.event;
  var target = e.target ? e.target : e.srcElement;

  target.time.endTime().send();

  // Resource has loaded. Print out the time it took to the screen.
  document.getElementById('demo1Time').innerHTML += [
    'It took',
    target.time.elapsedTime,
    'milliseconds to load jQuery from',
    target.time.label,
    '<br>'].join(' ');
}


/**
 * Demo 2.
 * This function demonstrates how to track the amount of time it takes
 * to GET a resource using the XMLHttpRequest object.
 */
function runDemo2() {
  var url = cacheBust(C_QUOTES);
  var tt = new TrackTiming('xhr demo', 'load chuck norris quotes').debug();

  makeXhrRequest(url, demo2callback, tt);
}


/**
 * Makes a GET request to the URL using the XMLHttpRequest object.
 * A TrackTiming object is used to capture the start time right before
 * the request is made. The trackTime object is set as a property of
 * the XMLHttpRequest object so that it can be retrieved inside the
 * callback. Finally this method assumes that the callback will end
 * the timer and send data to Google Analytics.
 * @param {String} url The URL to make make a GET request.
 * @param {Function} callback The callback function that will be executed
 *     everytime the readyState property of the XMLHttpRequest object
 *     changes.
 * @param {Object} tt An instance of TimeTracker. Used to track the
 *     time it takes for the XHR object to fetch a resource.
 */
function makeXhrRequest(url, callback, tt) {
  var xhr = getXMLHttpRequest();
  if (xhr) {
    xhr.open('GET', url, true);
    xhr.onreadystatechange = demo2callback;

    xhr.time = tt.startTime();

    xhr.send();
  }
}


/**
 * Callback function. This is called every time the XMLHttpRequest object
 * readyState property changes. The event contains a reference to the
 * XMLHttpRequest object that initiated the event. This reference is used
 * to retrieve the TrackTiming object, end the timer, and send the final
 * data onto Google Analytics.
 * @param {Object} event The readyState event object.
 */
function demo2callback(event) {
  var e = event || window.event;
  var target = e.target ? e.target : e.srcElement;

  if (target.readyState == 4) {
    if (target.status == 200) {

      target.time.endTime().send();

      // Resource has loaded.
      document.getElementById('xhrOutput').innerHTML = target.responseText;
      document.getElementById('demo2Time').innerHTML =
          'Took ' + target.time.elapsedTime + ' milliseconds.';
    }
  }
}


/**
 * Simple cross browser helper mettod to get the right XMLHttpRequst object
 * for older IE browsers. Since IE makes us jump through hoops, might as well
 * use Microsoft's example: http://msdn.microsoft.com/en-us/library/ie/ms535874(v=vs.85).aspx
 */
function getXMLHttpRequest() {
  if (window.XMLHttpRequest) {
    return new window.XMLHttpRequest;
  }
  else {
    try {
      return new ActiveXObject("MSXML2.XMLHTTP.3.0");
    } catch(e) {
      return null;
    }
  }
}


/**
 * Utility function to add a random number as a query parameter to the url.
 * This assumes the URL doesn't have any existing query parameters or
 * anchor tags.
 * @param {String} url The url to add cache busting to.
 */
function cacheBust(url) {
  return url + '?t=' + Math.round(Math.random() * 100000);
}


/**
 * Simple class to encapsulate all logic dealing witt tracking time in Google
 * Analytics. This constructor accepts all the time tracking string values.
 * Calling startTime begins the timer. Calling endTime ends the period of time
 *     being tracked.
 * Callin sendTime sends the data to Google Analytics.
 * @param {String} category The _trackTiming category.
 * @param {String} variable The _trackTiming variable.
 * @param {?String} label The optional _trackTiming label. If not set with a
 *     real value, the value of undefined is used.
 * @return {Object} This TrackTiming instance. Useful for chaining.
 * @constructor.
 */
function TrackTiming(category, variable, opt_label) {

  /**
   * Maximum time that can elapse for the tracker to send data to Google
   * Analytics. Set to 10 minutes in milliseconds.
   * @type {Number}
   */
  this.MAX_TIME = 10 * 60 * 1000;

  this.category = category;
  this.variable = variable;
  this.label = opt_label ? opt_label : undefined;
  this.startTime;
  this.elapsedTime;
  this.isDebug = false;
  return this;
}

/**
 * Starts the timer.
 * @return {Object} This TrackTiming instance. Useful for chaining.
 */
TrackTiming.prototype.startTime = function() {
  this.startTime = new Date().getTime();
  return this;
};


/**
 * Ends the timer and sets the elapsed time.
 * @return {Object} This TrackTiming instance. Useful for chaining.
 */
TrackTiming.prototype.endTime = function() {
  this.elapsedTime = new Date().getTime() - this.startTime;
  return this;
};


/**
 * Enables or disables the debug option. When set, this will override the
 * default sample rate to 100% and output each request to the console.
 * When set to false, will send the default sample rate configured by
 * calling the _setSampleRate tracking method.
 * @param {?Boolean} opt_enable Enables or disables debug mode. If not present,
 *     debug mode will be enabled.
 * @return {Object} This TrackTiming instance. Useful for chaining.
 */
TrackTiming.prototype.debug = function(opt_enable) {
  this.isDebug = opt_enable == undefined ? true : opt_enable;
  return this;
};


/**
 * Send data to Google Analytics witt the configured variable, action,
 * elapsed time and label. This function performs a check to ensure that
 * the elapsed time is greater than 0 and less than MAX_TIME. This check
 * ensures no bad data is sent if the browser client time is off. If
 * debug has been enebled, then the sample rate is overridden to 100%
 * and all the tracking parameters are outputted to the console.
 * @return {Object} This TrackTiming instance. Useful for chaining.
 */
TrackTiming.prototype.send = function() {
  if (0 < this.elapsedTime && this.elapsedTime < this.MAX_TIME) {

    var command = ['_trackTiming', this.category, this.variable,
        this.elapsedTime, this.label];

    if (this.isDebug) {
      // Override sample rate if debug is enabled.
      command.push(100);

      if (window.console && window.console.log) {
         console.log(command);
      }
    }

    window._gaq.push(command);
  }
  return this;
};
