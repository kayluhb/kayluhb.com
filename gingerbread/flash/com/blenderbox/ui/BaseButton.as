package com.blenderbox.ui
{
	import com.blenderbox.events.BaseButtonEvent;
	import flash.display.*;
	import flash.events.*;
	import flash.text.TextField;
	
	/**
	* @author cbrown
	*/
	public class BaseButton extends Sprite 
	{
		public var _enabled:Boolean = false;
		public var id:Number = 0;
		public var state:String = "off";
		public var deepLink:String = "";
		
		public function BaseButton() {
			focusRect = false;
			hit.focusRect = false;
			enabled = true;
		}
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(_enabled:Boolean):void {
			if (this._enabled != _enabled) {
				this._enabled = _enabled;
				setButtonEvents();
			}
		}
		public function handlePress(event:MouseEvent):void { this.dispatchEvent(new BaseButtonEvent(BaseButtonEvent.HANDLE_PRESS, id, deepLink)); }
		public function handleRelease(event:MouseEvent):void { this.dispatchEvent(new BaseButtonEvent(BaseButtonEvent.HANDLE_RELEASE, id, deepLink)); }
		public function handleRollOut(event:MouseEvent):void { this.dispatchEvent(new BaseButtonEvent(BaseButtonEvent.HANDLE_OUT, id)); }
		public function handleRollOver(event:MouseEvent):void { this.dispatchEvent(new BaseButtonEvent(BaseButtonEvent.HANDLE_OVER, id)); }
		
		// private button functions
		private function addEvents():void {
			hit.buttonMode = true;
			hit.useHandCursor = true;
			hit.addEventListener(MouseEvent.MOUSE_DOWN, handlePress);
			hit.addEventListener(MouseEvent.MOUSE_UP, handleRelease);
			hit.addEventListener(MouseEvent.ROLL_OUT, handleRollOut);
			hit.addEventListener(MouseEvent.ROLL_OVER, handleRollOver);
			this.dispatchEvent(new BaseButtonEvent(BaseButtonEvent.HANDLE_ENABLED));
		}
		private function removeEvents():void {
			hit.buttonMode = false;
			hit.useHandCursor = false;
			hit.removeEventListener(MouseEvent.MOUSE_DOWN, handlePress);
			hit.removeEventListener(MouseEvent.MOUSE_UP, handleRelease);
			hit.removeEventListener(MouseEvent.ROLL_OUT, handleRollOut);
			hit.removeEventListener(MouseEvent.ROLL_OVER, handleRollOver);
			this.dispatchEvent(new BaseButtonEvent(BaseButtonEvent.HANDLE_DISABLED));
		}
		private function setButtonEvents():void {
			if (_enabled) addEvents();
			else removeEvents();
		}
	}
}