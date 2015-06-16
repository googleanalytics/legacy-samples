package com.google.analytics.events
{
	import flash.events.Event;

	public class GAEvent extends Event
	{
		
		public static const ERROR:String 			= "error";
		
		public var errorMessage:String 				= "";
		
		public function GAEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}