#summary Installation Documentation

## GA.JS AS3 Bridge Install Guide

First read the usage guide GaAs3Bridge to understand how both parts of the bridge work
Depending on the your developing environment, there are couple of ways to install the bridge :

  * In Flex Builder: in the project's library path include the [http://actionscript3-event-tracking.googlecode.com/files/GATracker.swc SWC complied class] 
  * In Flash CS3: install the  [http://actionscript3-event-tracking.googlecode.com/files/GATracker.mxp component extension]

## In Flex Builder

  * First download the GATracker.swc file: http://actionscript3-event-tracking.googlecode.com/files/GATracker.swc

  * Open or create a new Flex project and click on : Project -> Properties -> Flex Build Path
  * On the Library Path tab, click "add SWC..." and browse to the file above
  * You should see GATrracker in the Build Path Libraries
  * Click ok and go back to the project

On the mxml or as3 file you want to track, you need to import the class 


`import com.google.analytics.GATracker`
