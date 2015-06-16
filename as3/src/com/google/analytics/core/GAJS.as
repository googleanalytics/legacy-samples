/**
 * Google Analytics AS3->JS tracking bridge based on ga.js v4
 * Authors: Jesse Warden, Nick Mihailovski 2008
 * Developed under the Apache License 2.0
 * Code hosted at : http://actionscript3-event-tracking.googlecode.com/svn/
 * 
 * This class implements all of the functionality found in GA.js v4 except for a few minor changes.
 ** Class constructor takes in the account number and creates the tracking JS object. Optional bool parameter when true 
 **    allows an AS3 class to be made without a corresponding JS object
 *
 * 
 * This JS code needs to be in the host container for functionality to work : 
 * 
 * 	var _GAtrack = {}; 	function _createGAObj(id) { window._GAtrack[id] = _gat._getTracker(id); }
 * 
*/
package com.google.analytics.core
{
	import com.google.analytics.events.GAEvent;
	import com.google.analytics.vo.TransactionVO;
	
	import flash.external.ExternalInterface;
	import flash.events.EventDispatcher;
	
	[Event(name="error", type="com.google.analytics.events.GAEvent")]
	public class GAJS extends EventDispatcher implements IGA
	{
		
		// -----------------------------------------------------------------------------
		public function GAJS(uacct:String, createJSObj:Boolean=true, target:EventDispatcher=null):void
		{
			super(target);
			__uacct = uacct;
			if (createJSObj) {
				createExternalGAObj();
			}
		}
		
	
		// -- START Configuration --	
		// -----------------------------------------------------------------------------
		public function getAccount():String
		{
			return callJSObj("_getAccount");
		}
		
		// -----------------------------------------------------------------------------
		public function getVersion():String
		{
			return callJSObj("_getVersion");
		}
		
		// -----------------------------------------------------------------------------
		// call _createGAObj in container to create JS tracking object
		protected function createExternalGAObj():void {
			jsExternal("_createGAObj", __uacct);
		}
		
		// -----------------------------------------------------------------------------
		public function initData():void
		{
			callJSObj("_initData");
		}
		
		// -----------------------------------------------------------------------------
		public function setSampleRate(newRate:Number):void
		{
			callJSObj("_setSampleRate", newRate);
		}

		// -----------------------------------------------------------------------------
		public function setSessionTimeout(newTimeout:int):void
		{
			callJSObj("_setSessionTimeout", newTimeout);
		}
		
		// -----------------------------------------------------------------------------
		public function setVar(newVal:String):void
		{
			callJSObj("_setVar", newVal);
		}
		
		// -----------------------------------------------------------------------------
		public function trackPageview(pageURL:String=""):void
		{
			if(pageURL != "")
			{
				callJSObj("_trackPageview", pageURL);
			}
			else
			{
				callJSObj("_trackPageview");
			}
		}
		
		// -- END Configuration --
		
		// -- START Campaign --
		
		// -----------------------------------------------------------------------------
		public function setAllowAnchor(enable:Boolean):void
		{
			callJSObj("_setAllowAnchor", enable);
		}
		
		// -----------------------------------------------------------------------------
		public function setCampContentKey(newCampContentKey:String):void
		{
			callJSObj("_setCampContentKey", newCampContentKey);
		}
		
		// -----------------------------------------------------------------------------
		public function setCampMediumKey(newCampMedKey:String):void
		{
			callJSObj("_setCampMediumKey", newCampMedKey);
		}
		
		// -----------------------------------------------------------------------------
		public function setCampNameKey(newCampNameKey:String):void
		{
			callJSObj("_setCampNameKey", newCampNameKey);
		}
		
		// -----------------------------------------------------------------------------
		public function setCampNOKey(newCampNOKey:String):void
		{
			callJSObj("_setCampNOKey", newCampNOKey);
		}
		
		// -----------------------------------------------------------------------------
		public function setCampSourceKey(newCampSrcKey:String):void
		{
			callJSObj("_setCampSourceKey", newCampSrcKey);
		}
		
		// -----------------------------------------------------------------------------
		public function setCampTermKey(newCampTermKey:String):void
		{
			callJSObj("_setCampTermKey", newCampTermKey);
		}
		
		// -----------------------------------------------------------------------------
		public function setCampaignTrack(enable:Boolean):void
		{
			callJSObj("_setCampaignTrack", enable);
		}
		
		// -----------------------------------------------------------------------------
		public function setCookieTimeout(newDefaultTimeout:Number):void
		{
			callJSObj("_setCookieTimeout", newDefaultTimeout);
		}
		
		// -- END Campaign --
		
		// -- START Domains & Directories --
		
		// -----------------------------------------------------------------------------
		public function cookiePathCopy(newPath:String):void
		{
			callJSObj("_cookiePathCopy", newPath);
		}
		
		// -----------------------------------------------------------------------------
		public function link(targetUrl:String, useHash:String):void
		{
			callJSObj("_link", targetUrl, useHash);
		}
		
		// -----------------------------------------------------------------------------
		public function linkByPost(formObject:Object, useHash:Boolean):void
		{
			callJSObj("_linkByPost", formObject, useHash);
		}
		
		// -----------------------------------------------------------------------------		
		public function getLinkerUrl(url:String):String
		{
			return callJSObj("_getLinkerUrl", url);	
		//	return jsExternal("_GAtrack['UA-5-1']._getLinkerUrl","www.test.com");
		}
		
		// -----------------------------------------------------------------------------
		public function setAllowHash(enable:Boolean):void
		{
			callJSObj("_setAllowHash", enable);
		}
		
		// -----------------------------------------------------------------------------
		public function setAllowLinker(enable:Boolean):void
		{
			
			callJSObj("_setAllowLinker", enable);
		}
		
		// -----------------------------------------------------------------------------
		public function setCookiePath(newCookiePath:String):void
		{
			callJSObj("_setCookiePath", newCookiePath);
		}
		
		// -----------------------------------------------------------------------------
		public function setDomainName(newDomainName:Boolean):void
		{
			callJSObj("_setDomainName", newDomainName);
		}
		
		// -- END Domains & Directories --
		
		// -- START Ecommerce --
		
		// -----------------------------------------------------------------------------
		public function addItem(item:String, 
								sku:String, 
								name:String, 
								category:String, 
								price:Number, 
								quantity:Number):void
		{
			callJSObj("_addItem", item, sku, name, category, price, quantity);
		}
		
		// -----------------------------------------------------------------------------
		public function addTrans(orderID:String,
									affiliation:String, 
									total:Number, 
									tax:Number, 
									shipping:Number, 
									city:String, 
									state:String, 
									country:String):TransactionVO
		{
			var obj:Object = callJSObj("_addTrans", orderID, affiliation, total, tax, shipping, city, state, country);	
			if(obj != null)
			{
				var transaction:TransactionVO = new TransactionVO();
				return transaction;
			}
			else
			{
				return null;
			}
		}
		
		// -----------------------------------------------------------------------------
		public function trackTrans():void
		{
			callJSObj("_trackTrans");
		}
		
		// -- END Ecommerce --
		
		// -- START Event Tracking --
		
		// -----------------------------------------------------------------------------
		public function trackEvent(obj:String, action:String, label:String="", value:Number=0):Boolean 
		{
			value = isNaN(value) ? 0 : value;
			return callJSObj("_trackEvent", obj, action, label, value);	
		}
		
		// -- END Event Tracking --
		
		// -- START Search Engines and Referrers --
		
		// -----------------------------------------------------------------------------
		public function addIgnoredOrganic(newIgnoredOrganicKeyword:String):void
		{
			callJSObj("_addIgnoredOrganic", newIgnoredOrganicKeyword);
		}
		
		// -----------------------------------------------------------------------------
		public function addIgnoredRef(newIgnoredReferrer:String):void
		{
			callJSObj("_addIgnoredRef", newIgnoredReferrer);
		}
		
		// -----------------------------------------------------------------------------
		public function addOrganic(newOrganicEngine:String, newOrganicKeyword:String):void
		{
			callJSObj("_addOrganic", newOrganicEngine, newOrganicKeyword);	
		}
		
		// -----------------------------------------------------------------------------
		public function clearIgnoredOrganic():void
		{
			callJSObj("_clearIgnoredOrganic");
		}
		
		// -----------------------------------------------------------------------------
		public function clearIgnoredRef():void
		{
			callJSObj("_clearIgnoredRef");
		}
		
		// -----------------------------------------------------------------------------
		public function clearOrganic():void
		{
			callJSObj("_clearOrganic");
		}
		
		// -- END Search Engines and Referrers --
		
		// -- START Web Client --
		
		// -----------------------------------------------------------------------------
		public function getClientInfo(bool:Boolean):Number
		{
			return callJSObj("_getClientInfo", bool);
		}
		
		// -----------------------------------------------------------------------------
		public function getDetectFlash(bool:Boolean):Number
		{
			return callJSObj("_getDetectFlash", bool);
		}
		
		// -----------------------------------------------------------------------------
		public function getDetectTitle(bool:Boolean):Number
		{
			return callJSObj("_getDetectTitle", bool);
		}
		
		// -----------------------------------------------------------------------------
		public function setClientInfo(enable:Boolean):void
		{
			callJSObj("_setClientInfo", enable);
		}
		
		// -----------------------------------------------------------------------------
		public function setDetectFlash(enable:Boolean):void
		{
			callJSObj("_setDetectFlash", enable);
		}
		
		// -----------------------------------------------------------------------------
		public function setDetectTitle(enable:Boolean):void
		{
			callJSObj("_setDetectTitle", enable);
		}
		
		// -- END Web Client --
		
		// -- START Urchin Server --
		
		// -----------------------------------------------------------------------------
		public function getLocalGifPath():String
		{
			return callJSObj("_getLocalGifPath");
		}
		
		// -----------------------------------------------------------------------------
		public function getServiceMode():Number
		{
			return callJSObj("_getServiceMode");
		}
		
		// -----------------------------------------------------------------------------
		public function setLocalGifPath(newLocalGifPath:String):void
		{
			callJSObj("_setLocalGifPath", newLocalGifPath);
		}
		
		// -----------------------------------------------------------------------------
		public function setLocalRemoteServerMode():void
		{
			callJSObj("_setLocalRemoteServerMode");
		}
		
		// -----------------------------------------------------------------------------
		public function setLocalServerMode():void
		{
			callJSObj("_setLocalServerMode");
		}
		
		// -----------------------------------------------------------------------------
		public function setRemoteServerMode():void
		{
			callJSObj("_setRemoteServerMode");
		}
		
		// -- END Urchin Server --
		
		// -----------------------------------------------------------------------------
		public function destroy():void
		{
		}
		
		// -----------------------------------------------------------------------------
		protected function callJSObj(jsMethodName:String, ...args):*
		{
			jsMethodName = "window."+ __JSTrackObj +"['"+ __uacct +"']."+ jsMethodName;
			args.unshift(jsMethodName);
			return jsExternal.apply(jsExternal, args);
		//	return jsExternal(jsMethodName, args);
		}	
		
		// -----------------------------------------------------------------------------
		protected function jsExternal(jsMethodName:String, ... args):*
		{	
			var jsResult:*;
			if(ExternalInterface.available == true)
			{
				try
				{
					args.unshift(jsMethodName);
					jsResult = ExternalInterface.call.apply(ExternalInterface, args);
					return jsResult;
				}
				catch(err:SecurityError)
				{
					dispatchError("ExternalInterface is not available.  Ensure that allowScriptAccess is set to 'always' in the Flash embed HTML.");
				}
				catch(err:Error)
				{
					dispatchError("ExternalInterface failed to make the call, reason: " + err.message);
				}
			}
			else
			{
				dispatchError("ExternalInterface is not available.");
			}
		}
		
		// -----------------------------------------------------------------------------
		protected function dispatchError(errorString:String):void
		{
			var event:GAEvent = new GAEvent(GAEvent.ERROR);
			event.errorMessage = errorString;
			dispatchEvent(event);
		}
		
		// -----------------------------------------------------------------------------
		private var __JSTrackObj:String 			= "_GAtrack"; 
		private var __uacct:String;

	}
}