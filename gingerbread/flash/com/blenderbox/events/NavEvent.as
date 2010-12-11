/**
* @author cbrown
*/
package com.blenderbox.events 
{
	import flash.events.Event;
	
	public class NavEvent extends Event  
	{
		public static const BY_ID:String 	= "onById";
		public static const NEXT:String 	= "onNext";
		public static const PREVIOUS:String = "onPrevious";
		
		public var id:Number = 0;
		public var direction:String = "";
		
		public function NavEvent(type:String, id:Number = 0, bubbles:Boolean = false, cancelable:Boolean = false) {
			this.id = id;
			super(type, bubbles, cancelable);
		}
	}
	
}