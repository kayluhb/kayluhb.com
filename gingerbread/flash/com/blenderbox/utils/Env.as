/**
* @author cbrown
*/
package com.blenderbox.utils 
{
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	
	public class Env 
	{
		
		internal var environment:Dictionary;
		private static var instance:Env;
		
		public function Env(key:SingletonBlocker):void 
		{
			// this shouldn't be necessary unless they fake out the compiler:
			if (key == null)  throw new Error("Error: Instantiation failed: Use Env.getInstance() instead of new.");
		}
		// publics
		public static function get isOnline():Boolean {
			return (Capabilities.playerType == "PlugIn" || Capabilities.playerType == "ActiveX");
		}
		public static function getValue(key:String) { return Env.getInstance().environment[key]; }
		public static function setValue(key:String, value):void { Env.getInstance().environment[key] = value; }
		
		public static function getInstance():Env {
			if (instance == null) {
				instance = new Env(new SingletonBlocker());
				instance.init();
			}
			return instance;
		}
		
		// privates
		private function init():void { environment = new Dictionary(true); }
		
	}
}
internal class SingletonBlocker {}
