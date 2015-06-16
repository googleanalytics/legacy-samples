#summary Overview and Usage Documentation

## GA.JS AS3 Bridge Documentation v2

The purpose of the GA.JS - AS3 Bridge is to make it easy for Flash and Flex developers to use Google Analytics in their applications. The "bridge" provides an !ActionScript 3 class for all the functions provided in ga.js and actually uses the ga.js functionality to send data to Google servers.

###Typical use cases include :
  * Tracking Flash/Flex based websites 
  * Tracking both web pages and embedded Flash/Flex content in the same account
  * Embedded Flash/Flex content where the developer has control over the container HTML page

###Non use cases include :
  * Flash/Flex content not on web pages (ie. offline AIR applications)
  * Content where allowscript access is disabled
  * Embedded content where the developer *does not* have control over the container page


# Usage Details

There are 2 parts to the GA.JS-AS3 Bridge
  * A snippet of !JavaScript helper code
  * The !ActionScript class itself 

### 1. !JavaScript helper code
 
The snippet of JS helper code does a couple of things to simplify the work of the AS3 class. For one, it creates a standardized way to reference the ga.js tracking object. It also allows !ActionScript to set !JavaScript variables for the core tracking and supplemental event tracking objects. It also adds a utility to extract the GA cookie data as a string

This snippet of JS code needs to be added *before* the Flash/Flex SWF file is embedded for the bridge to properly work:


    <script>
    var _GAtrack = {}; function _createGAObj(id) { window._GAtrack[id] = _gat._getTracker(id); }
    </script>


####So what does this do?
  * It creates a global variable `_GAtrack` which will hold GA tracking objects

  To track a page view in !JavaScript using this methodology you would use :

    var id = "UA-5-1";
    _createGAObj(id);
    _GAtrack[id]._initData();
    _GAtrack[id]._trackPageview();


  To reference `_GAtrack` from within a JS function, you can pre-pend `window.` such as :

    var id = "UA-5-1";
    _createGAObj(id);  
    
    function myFunction() {
       window._GAtrack[id]._initData();
       window._GAtrack[id]._trackPageview();
    }


### 2. The !ActionScript class itself

#### Differences
For the most part, this class adheres to GA.JS v4 tracking API outlined here: http://code.google.com/apis/analytics/docs/gaJSApi.html

Although there are a couple of differences.

  * The constructor for the AS3 object is `GATrack(accountId:String, createJSTrackingObj:Boolean=true)` By default when the AS3 object is created a corresponding JS tracking object is also created in `_GATrack[id]` But there might be times when a tracking object has been already created or 2 SWFs are trying to access the same JS code. Instead of recreating the JS tracking object, you can set `createJSTrackingObj` to `false` and only a reference to the existing JS will be created in AS3. 


####Error Handling

_More documentation needed on GAError_