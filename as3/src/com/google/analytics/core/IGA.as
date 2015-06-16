package com.google.analytics.core
{
	import com.google.analytics.vo.TransactionVO;
	
	public interface IGA
	{
		
		function destroy():void;
		
		// -----------------------------------------------------------------------------
		function getAccount():String;
		
		// -----------------------------------------------------------------------------
		function getVersion():String;
		
		// -----------------------------------------------------------------------------
		function initData():void;
		
		// -----------------------------------------------------------------------------
		function setSampleRate(newRate:Number):void;

		// -----------------------------------------------------------------------------
		function setSessionTimeout(newTimeout:int):void;
		
		// -----------------------------------------------------------------------------
		function setVar(newVal:String):void;
		
		// -----------------------------------------------------------------------------
		function trackPageview(pageURL:String=""):void;
		
		// -- END Configuration --
		
		// -- START Campaign --
		
		// -----------------------------------------------------------------------------
		function setAllowAnchor(enable:Boolean):void;
		
		// -----------------------------------------------------------------------------
		function setCampContentKey(newCampContentKey:String):void;
		
		// -----------------------------------------------------------------------------
		function setCampMediumKey(newCampMedKey:String):void;
		
		// -----------------------------------------------------------------------------
		function setCampNameKey(newCampNameKey:String):void;
		
		// -----------------------------------------------------------------------------
		function setCampNOKey(newCampNOKey:String):void;
		
		// -----------------------------------------------------------------------------
		function setCampSourceKey(newCampSrcKey:String):void;
		
		// -----------------------------------------------------------------------------
		function setCampTermKey(newCampTermKey:String):void;
		
		// -----------------------------------------------------------------------------
		function setCampaignTrack(enable:Boolean):void;
		
		// -----------------------------------------------------------------------------
		function setCookieTimeout(newDefaultTimeout:Number):void;
		
		// -- END Campaign --
		
		// -- START Domains & Directories --
		
		// -----------------------------------------------------------------------------
		// TODO: validate initData is called before this is run
		function cookiePathCopy(newPath:String):void;
		
		// -----------------------------------------------------------------------------
		// appends a all cookie information to end of targetURL and changes HTML's
		// document.location to be used with setAllowLinker
		function link(targetURL:String, useHash:String):void;
		
		// -----------------------------------------------------------------------------
		// function takes in a JS-DOM Form OBJ and appends it's action memeber with cookie 
		// information to be passed onto a 3rd party domain when submitted.
		// to be used by setAllowLinker
		function linkByPost(formObject:Object, useHash:Boolean):void;
		
		// -----------------------------------------------------------------------------
		// function takes a url and returns appended cookie information as a string
		// to be used by setAllowLinker
		function getLinkerUrl(url:String):String;		
		
		// -----------------------------------------------------------------------------
		function setAllowHash(enable:Boolean):void;
		
		// -----------------------------------------------------------------------------
		// used with link OR linkByPost. If enabled, puts data from URL into cookie
		function setAllowLinker(enable:Boolean):void;
		
		// -----------------------------------------------------------------------------
		function setCookiePath(newCookiePath:String):void;
		
		// -----------------------------------------------------------------------------
		function setDomainName(newDomainName:Boolean):void;
		
		// -- END Domains & Directories --
		
		// -- START Ecommerce --
		
		// -----------------------------------------------------------------------------
		function addItem(item:String, 
								sku:String, 
								name:String, 
								category:String, 
								price:Number, 
								quantity:Number):void;
		
		// -----------------------------------------------------------------------------
		// returns the transaction object modified in the GA which doesn't do anything ??
		function addTrans(orderID:String,
									affiliation:String, 
									total:Number, 
									tax:Number, 
									shipping:Number, 
									city:String, 
									state:String, 
									country:String):TransactionVO;
		
		// -----------------------------------------------------------------------------
		function trackTrans():void;
		
		// -- END Ecommerce --
		
		// -- START Event Tracking --
		
		/* -----------------------------------------------------------------------------
		function createEventTracker(objName:String):Object;
		
		// -----------------------------------------------------------------------------
		//function trackEvent(eventType:String, label:String="", value:String=""):Boolean;
		*/
		
		// -----------------------------------------------------------------------------
		function trackEvent(obj:String, action:String, label:String="", value:Number=0):Boolean;
		
		// -- END Event Tracking --
		
		// -- START Search Engines and Referrers --
		
		// -----------------------------------------------------------------------------
		function addIgnoredOrganic(newIgnoredOrganicKeyword:String):void;
		
		// -----------------------------------------------------------------------------
		function addIgnoredRef(newIgnoredReferrer:String):void;
		
		// -----------------------------------------------------------------------------
		function addOrganic(newOrganicEngine:String, newOrganicKeyword:String):void;
		
		// -----------------------------------------------------------------------------
		function clearIgnoredOrganic():void;
		
		// -----------------------------------------------------------------------------
		function clearIgnoredRef():void;
		
		// -----------------------------------------------------------------------------
		function clearOrganic():void;
		
		// -- END Search Engines and Referrers --
		
		// -- START Web Client --
		
		// -----------------------------------------------------------------------------
		// JS doesn't need param
		function getClientInfo(bool:Boolean):Number;
		
		// -----------------------------------------------------------------------------
		// JS param exisits but not needed
		function getDetectFlash(bool:Boolean):Number;
		
		// -----------------------------------------------------------------------------
		// JS doesn't need param		
		function getDetectTitle(bool:Boolean):Number;
		
		// -----------------------------------------------------------------------------
		function setClientInfo(enable:Boolean):void;
		
		// -----------------------------------------------------------------------------
		function setDetectFlash(enable:Boolean):void;
		
		// -----------------------------------------------------------------------------
		function setDetectTitle(enable:Boolean):void;
		
		// -- END Web Client --
		
		// -- START Urchin Server --
		
		// -----------------------------------------------------------------------------
		function getLocalGifPath():String;
		
		// -----------------------------------------------------------------------------
		function getServiceMode():Number;
		
		// -----------------------------------------------------------------------------
		function setLocalGifPath(newLocalGifPath:String):void;
		
		// -----------------------------------------------------------------------------
		function setLocalRemoteServerMode():void;
		
		// -----------------------------------------------------------------------------
		function setLocalServerMode():void;
		
		// -----------------------------------------------------------------------------
		function setRemoteServerMode():void;
		
		// -- END Urchin Server --
	}
}