NOTE PAD APPLICATION TRACKING EXAMPLE
======================

This Android application enhances the existing Android sample notepad application
by demonstrating how to use the Google Analytics SDK for Android.

Specifically it demonstrates how to:
- track the activities as page views
- track from which activities notes are deleted using event tracking
- track the orientation of the device using custom variables


BUILDING THE EXAMPLE
----------------------
To build the example you must:

1. Download the Android SDK here:
http://developer.android.com/sdk/index.html

2. Download the Google Analytics SDK for Android here:
http://code.google.com/mobile/analytics/download.html#Google_Analytics_SDK_for_Android

3. Next link the library to your project

4. Next you need to modify your AndroidManifext.xml file with the
following two permissions.

<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

5. Finally the example is build with minimum version 1.5 which we recommend you
configure the project to also use.

For more information about the SDK, please see the documentation at:
http://code.google.com/mobile/analytics/docs/android/
