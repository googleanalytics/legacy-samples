Android Market Campaign Tracking Tool

Copyright 2012 Google, Inc. All rights reserved.

===============================================================================
DESCRIPTION:

This tool enables developers to test their Google Analytics Android SDK
implementation to verify whether it is configured to receive campaign referral
data from the Android Market.

The tool simulates an Android Market download by building an INSTALL_REFERRER
intent based on an Android Market URL you provide, and broadcasting it to the
application that you specify.

You can then use the debug info provided by the tool itself, as well as the
logcat output of the Google Analytics implementation within your own
application, to determine whether the broadcast was received and the
referral information was successfully stored within your application.



===============================================================================
HOW TO USE THE TOOL

Requirements

The tool assumes you already have a working Google Analytics implementation
within the application you are trying to test. For more information on how to
implement Google Analytics in your application, please see the SDK
documentation here:
http://code.google.com/apis/analytics/docs/mobile/android.html

You should also make sure the debug and dryRun flags within the SDK are set
prior to using the tool.

To use the tool:

1. Build and run the application that you’d like to test on either your Android
Virtual Device (AVD) or tethered external device.

2. Build and run the Android Campaign Tracking Tool on that same AVD or
tethered device.


3. Enter the Android Market destination URL that you’re planning to use with
your ads or links to the Market. For example, an example Market destination URL
might look like this:

http://market.android.com/details?id=com.example.application
&referrer=utm_source%3Dgoogle%26utm_medium%3Dcpc%26utm_campaign%3Dmycampaign

For more information on how to build Android Market URLs, please see the
Android Market Campaign Tracking section fo the SDK documentation here:

http://code.google.com/apis/analytics/docs/mobile/android.html#android-market-tracking

4. Enter the package name of the application you’d like to test (the same
application you built and ran in Step 1).

5. Press the ‘Send’ button to build the INSTALL_REFERRER intent and broadcast
it to the target application.

6. The tool itself will display some errors and warnings if it detects problems
with the Android Market URL or if it was unable to build the INSTALL_REFERRER
intent for any reason.

If the broadcast is sent successfully, you’ll want to then check the logcat
output for the target application. In particular, you’ll want to check any logs
from the category ‘GoogleAnalyticsTracker’, the Google Analytics class that is
handling the receipt and storage of the referral information from the
INSTALL_REFERRER intent.

Those logs will confirm whether the intent was received and whether the
referral information was stored successfully.


===============================================================================
TROUBLESHOOTING


Why am I not seeing any logcat output for the category ‘GoogleAnalyticsTracker’
in my target application?

There could be several reasons that you aren’t seeing logs in logcat for the
category ‘GoogleAnalyticsTracker’ in your target application:

1. The debug flag has not been set in the target application’s Analytics
implementation. You must set the flag in order for the class to output logs to
logcat.

2. The target application’s package name was input incorrectly into the tool.
Make sure that you are entering the package name of your target application
correctly before pressing ‘Send’.

3. The necessary BroadcastReceiver has not been added to the target
application’s AndroidManifest.xml file.  You can verify that you’ve added the
appropriate BroadcastReceiver by reviewing the documentation here:
http://code.google.com/apis/analytics/docs/mobile/android.html#android-market-tracking.


===============================================================================
BUILD REQUIREMENTS:

Android SDK 1.5+

===============================================================================
RUNTIME REQUIREMENTS:

Android OS 1.5+

===============================================================================
PACKAGING LIST:

CampaignTrackingTool
|-- libGoogleAnalytics.jar
|-- ReadMe.text
|-- AndroidManifest.xml
|-- res
|   |-- drawable
|   |   `-- icon.png
|   |-- layout
|   |   `-- main.xml
|   `-- values
|       `-- strings.xml
`-- src
    `-- com
        `-- campaigntracking
             `-- app
                  |-- CampaignTrackingActivity.java
                  |-- Log.java
                  |-- Market.java
                  |-- QueryString.java

===============================================================================
