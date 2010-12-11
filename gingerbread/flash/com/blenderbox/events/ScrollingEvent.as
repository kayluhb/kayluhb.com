/**
* @author cbrown
*/
package com.blenderbox.events 
{
	import flash.events.Event;
	
	public class ScrollingEvent extends Event {
		
		public static const ON_CHANGE:String = "onChange";
		
		public function ScrollingEvent(type) {
			super(type, false, false);
		}
	}
}