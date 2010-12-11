/**
* @author cbrown
*/
package com.blenderbox.events
{
	import flash.events.Event;
	
	public class ImageEvent extends Event
	{
		public static const ON_HIDE:String = "onHide";
		public static const ON_LOAD:String = "onLoad";
		public static const ON_PROGRESS:String = "onProgress";
		public static const ON_SHOW:String = "onShow";
		
		public var image;
		
		public function ImageEvent(type:String, image = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			this.image = image;
			super(type, bubbles, cancelable);
		}
	}
}