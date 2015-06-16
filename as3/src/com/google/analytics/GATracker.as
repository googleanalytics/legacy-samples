package com.google.analytics
{
	import com.google.analytics.core.GAJS;
	import com.google.analytics.core.IGA;
	import com.google.analytics.vo.TransactionVO;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class GATracker extends EventDispatcher implements IGA
	{
		
		public static const TYPE_JAVASCRIPT_BRIDGE:uint 				= 0;
		public static const TYPE_ACTIONSCRIPT3:uint						= 1;
		
		
		// -----------------------------------------------------------------------------
		public function GATracker(uacct:String, target:IEventDispatcher=null):void
		{
			super(target);
			__uacct = uacct;
			setEventTrackerType(TYPE_JAVASCRIPT_BRIDGE);
		}
		
		// -----------------------------------------------------------------------------
		public function setEventTrackerType(type:uint):void
		{
			__type = type;
			switch(__type)
			{
				case TYPE_JAVASCRIPT_BRIDGE:
					createJavaScriptImpl();
					break;
				
				case TYPE_ACTIONSCRIPT3:
					createActionScriptImpl();
					break;
			}
		}
		
		// -----------------------------------------------------------------------------
		protected function createJavaScriptImpl():void
		{
			if(__impl != null)
			{
				__impl.destroy();
				__impl = null;
			}
			
			__impl = new GAJS(__uacct);
		}
		
		// -----------------------------------------------------------------------------
		// TODO: finish this mofo
		protected function createActionScriptImpl():void
		{
			if(__impl != null)
			{
				__impl.destroy();
				__impl = null;
			}
		}
		
		
		// -- START Configuration --
		
		// -----------------------------------------------------------------------------
		public function getAccount():String
		{
			return __impl.getAccount();
		}
		
		// -----------------------------------------------------------------------------
		public function getVersion():String
		{
			return __impl.getVersion();
		}
		
		// -----------------------------------------------------------------------------
		public function initData():void
		{
			__impl.initData();
		}
		
		// -----------------------------------------------------------------------------
		public function setSampleRate(newRate:Number):void
		{
			__impl.setSampleRate(newRate);
		}

		// -----------------------------------------------------------------------------
		public function setSessionTimeout(newTimeout:int):void
		{
			__impl.setSessionTimeout(newTimeout);
		}
		
		// -----------------------------------------------------------------------------
		public function setVar(newVal:String):void
		{
			__impl.setVar(newVal);
		}
		
		// -----------------------------------------------------------------------------
		public function trackPageview(pageURL:String=""):void
		{
			__impl.trackPageview(pageURL);
		}
		
		// -- END Configuration --
		
		// -- START Campaign --
		
		// -----------------------------------------------------------------------------
		public function setAllowAnchor(enable:Boolean):void
		{
			__impl.setAllowAnchor(enable);
		}
		
		// -----------------------------------------------------------------------------
		public function setCampContentKey(newCampContentKey:String):void
		{
			__impl.setCampContentKey(newCampContentKey);
		}
		
		// -----------------------------------------------------------------------------
		public function setCampMediumKey(newCampMedKey:String):void
		{
			__impl.setCampMediumKey(newCampMedKey);
		}
		
		// -----------------------------------------------------------------------------
		public function setCampNameKey(newCampNameKey:String):void
		{
			__impl.setCampNameKey(newCampNameKey);
		}
		
		// -----------------------------------------------------------------------------
		public function setCampNOKey(newCampNOKey:String):void
		{
			__impl.setCampNOKey(newCampNOKey);
		}
		
		// -----------------------------------------------------------------------------
		public function setCampSourceKey(newCampSrcKey:String):void
		{
			__impl.setCampSourceKey(newCampSrcKey);
		}
		
		// -----------------------------------------------------------------------------
		public function setCampTermKey(newCampTermKey:String):void
		{
			__impl.setCampTermKey(newCampTermKey);
		}
		
		// -----------------------------------------------------------------------------
		public function setCampaignTrack(enable:Boolean):void
		{
			__impl.setCampaignTrack(enable);
		}
		
		// -----------------------------------------------------------------------------
		public function setCookieTimeout(newDefaultTimeout:Number):void
		{
			__impl.setCookieTimeout(newDefaultTimeout);
		}
		
		// -- END Campaign --
		
		// -- START Domains & Directories --
		
		// -----------------------------------------------------------------------------
		// TODO: validate initData is called before this is run
		public function cookiePathCopy(newPath:String):void
		{
			__impl.cookiePathCopy(newPath);
		}
		
		// -----------------------------------------------------------------------------
		// Issue with Flash implementation, see IEventTracker.as
		public function link(targetURL:String, useHash:String):void
		{
			__impl.link(targetURL, useHash);
		}
		
		// -----------------------------------------------------------------------------
		// Issue with flash implementation see IEventTracker.as
		public function linkByPost(formObject:Object, useHash:Boolean):void
		{
			__impl.linkByPost(formObject, useHash);
		}
		
		// -----------------------------------------------------------------------------
		public function getLinkerUrl(url:String):String
		{
			return __impl.getLinkerUrl(url);
		}
		
		// -----------------------------------------------------------------------------
		public function setAllowHash(enable:Boolean):void
		{
			__impl.setAllowHash(enable);
		}
		
		// -----------------------------------------------------------------------------
		public function setAllowLinker(enable:Boolean):void
		{
			__impl.setAllowLinker(enable);
		}
		
		// -----------------------------------------------------------------------------
		public function setCookiePath(newCookiePath:String):void
		{
			__impl.setCookiePath(newCookiePath);
		}
		
		// -----------------------------------------------------------------------------
		public function setDomainName(newDomainName:Boolean):void
		{
			__impl.setDomainName(newDomainName);
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
			__impl.addItem(item, sku, name, category, price, quantity);
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
			return __impl.addTrans(orderID, affiliation, total, tax, shipping, city, state, country);
		}
		
		// -----------------------------------------------------------------------------
		public function trackTrans():void
		{
			__impl.trackTrans();
		}
		
		// -- END Ecommerce --
		
		// -- START Event Tracking --
		
		// -----------------------------------------------------------------------------
		/*
		public function createEventTracker(objName:String):Object
		{
			return __impl.createEventTracker(objName);
		}
		
		// -----------------------------------------------------------------------------
		public function trackEvent(action:String, label:String=null, value:String=null):Boolean
		{
			return __impl.trackEvent(action, label, value);
		}
		*/
		
		// -----------------------------------------------------------------------------
		public function trackEvent(object:String, action:String, label:String="", value:Number=0):Boolean 
		{
			return __impl.trackEvent(object, action, label, value);
			
		}
		
		// -- END Event Tracking --
		
		// -- START Search Engines and Referrers --
		
		// -----------------------------------------------------------------------------
		public function addIgnoredOrganic(newIgnoredOrganicKeyword:String):void
		{
			__impl.addIgnoredOrganic(newIgnoredOrganicKeyword);
		}
		
		// -----------------------------------------------------------------------------
		public function addIgnoredRef(newIgnoredReferrer:String):void
		{
			__impl.addIgnoredRef(newIgnoredReferrer);
		}
		
		// -----------------------------------------------------------------------------
		public function addOrganic(newOrganicEngine:String, newOrganicKeyword:String):void
		{
			__impl.addOrganic(newOrganicEngine, newOrganicKeyword);
		}
		
		// -----------------------------------------------------------------------------
		public function clearIgnoredOrganic():void
		{
			__impl.clearIgnoredOrganic();
		}
		
		// -----------------------------------------------------------------------------
		public function clearIgnoredRef():void
		{
			__impl.clearIgnoredRef();
		}
		
		// -----------------------------------------------------------------------------
		public function clearOrganic():void
		{
			__impl.clearOrganic();
		}
		
		// -- END Search Engines and Referrers --
		
		// -- START Web Client --
		
		// -----------------------------------------------------------------------------
		public function getClientInfo(bool:Boolean):Number
		{
			return __impl.getClientInfo(bool);
		}
		
		// -----------------------------------------------------------------------------
		public function getDetectFlash(bool:Boolean):Number
		{
			return __impl.getDetectFlash(bool);
		}
		
		// -----------------------------------------------------------------------------
		public function getDetectTitle(bool:Boolean):Number
		{
			return __impl.getDetectTitle(bool);
		}
		
		// -----------------------------------------------------------------------------
		public function setClientInfo(enable:Boolean):void
		{
			__impl.setClientInfo(enable);
		}
		
		// -----------------------------------------------------------------------------
		public function setDetectFlash(enable:Boolean):void
		{
			__impl.setDetectFlash(enable);
		}
		
		// -----------------------------------------------------------------------------
		public function setDetectTitle(enable:Boolean):void
		{
			__impl.setDetectTitle(enable);
		}
		
		// -- END Web Client --
		
		// -- START Urchin Server --
		
		// -----------------------------------------------------------------------------
		public function getLocalGifPath():String
		{
			return __impl.getLocalGifPath();
		}
		
		// -----------------------------------------------------------------------------
		public function getServiceMode():Number
		{
			return __impl.getServiceMode();
		}
		
		// -----------------------------------------------------------------------------
		public function setLocalGifPath(newLocalGifPath:String):void
		{
			__impl.setLocalGifPath(newLocalGifPath);
		}
		
		// -----------------------------------------------------------------------------
		public function setLocalRemoteServerMode():void
		{
			__impl.setLocalRemoteServerMode();
		}
		
		// -----------------------------------------------------------------------------
		public function setLocalServerMode():void
		{
			__impl.setLocalServerMode();
		}
		
		// -----------------------------------------------------------------------------
		public function setRemoteServerMode():void
		{
			__impl.setRemoteServerMode();
		}
		
		// -- END Urchin Server --
		
		// -----------------------------------------------------------------------------
		public function destroy():void
		{
			__impl.destroy();
		}
		
		
		protected var __impl:IGA;
		protected var __type:uint				= 0;
		private var __uacct:String;
		
	}
}