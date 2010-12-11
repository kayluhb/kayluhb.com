/**
* @author cbrown
*/
package com.blenderbox.events 
{
	import flash.events.Event;
	
	public class XmlLoadEvent extends Event 
	{
		public static const ON_LOAD:String = "XML_LOADED";
		
		public var xml:XML;

		public function XmlLoadEvent(type:String, xml:XML, bubbles:Boolean = false, cancelable:Boolean = false) {
			this.xml = xml;
			super(type, bubbles, cancelable);
		}
	}
}