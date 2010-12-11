/**
* @author cbrown
*/
package com.blenderbox.events
{
	import flash.events.MouseEvent;
	
	public class BaseButtonEvent extends MouseEvent 
	{
		public var id:Number = -1;
		public var deepLink:String = "";
		
		public static const HANDLE_PRESS:String = "onMousePress";
		public static const HANDLE_RELEASE:String = "onMouseRelease";
		public static const HANDLE_OUT:String 	= "onMouseOut";
		public static const HANDLE_OVER:String 	= "onMouseOver";
		public static const HANDLE_DISABLED:String 	= "onDisabled";
		public static const HANDLE_ENABLED:String 	= "onEnabled";
		
		public function BaseButtonEvent(type:String, id:Number = -1, deepLink:String = "") {
			this.id = id;
			this.deepLink = deepLink;
			super(type, false, false);
		}
	}
}