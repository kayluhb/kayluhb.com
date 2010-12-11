/**
* @author cbrown
*/
package com.blenderbox.net {
	
	import com.blenderbox.events.XmlLoadEvent;
	import flash.events.*;
	import flash.net.*;
	import flash.errors.*;

	public class XMLLoader extends EventDispatcher 
	{
		
		private var xmlRequest:URLRequest;
		private var xmlLoader:URLLoader;
		
		public function XMLLoader() { }
		// publics
		public function load(xmlPath:String):void {
			try {
				xmlRequest = new URLRequest(xmlPath);
				xmlLoader = new URLLoader();
				xmlLoader.addEventListener(Event.COMPLETE, xmlOnLoaded);
				xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
				xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
				xmlLoader.load(xmlRequest);
			} catch (error:Error) {
				trace("There was an error loading data", error);
			}
		}
		public function kill():void {
			// try catch if it's not open
			try { xmlLoader.close(); }
			catch (err:Error) {}
		}
		// event handlers
		private function xmlOnLoaded(e:Event):void {
			try {
				this.dispatchEvent(new XmlLoadEvent(XmlLoadEvent.ON_LOAD, new XML(e.target.data)));
			} catch (err:Error) {
				trace("Error parsing XML: " + err);
			}
		}
		private function onLoadError(e:Event):void {
			trace("Error during load: " + e);
		}
	}
}