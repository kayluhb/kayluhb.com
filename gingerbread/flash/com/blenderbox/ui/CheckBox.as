package com.blenderbox.ui
{
	import com.blenderbox.events.BaseButtonEvent;
	import flash.display.*;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.text.*;
	
	/**
	 * @author cbrown
	 */
	public class CheckBox extends Sprite
	{	
		private var glow:GlowFilter = new GlowFilter(0x8A999C, 1, 4, 4, 1, 3, true, false);
		private var _state:String = "off"; // on|off
		private var _value:Object;
		
		public function CheckBox() 
		{
			focusRect = false;
			addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			addEventListener(FocusEvent.FOCUS_OUT, onFocuOut);
			check.visible = false;
			check.alpha = 1;
			
			hit.buttonMode = true;
			hit.useHandCursor = true;
			hit.addEventListener(MouseEvent.CLICK, handleClick);
		}
		// publics
		public function get state():String { return _state; }
		
		public function set state(str:String):void {
			if (_state != str) {
				_state = str;
				onStateChange();
			}
			
		}
		public function handleClick(event:MouseEvent):void { this.dispatchEvent(new BaseButtonEvent(BaseButtonEvent.HANDLE_CLICK)); }
		
		private function toggleState():void {
			state = state == "on" ? "off" : "on";
		}
		// event handlers
		private function onFocusIn(e:FocusEvent):void {
			bg.filters = [glow];
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
		}
		private function onFocuOut(e:FocusEvent):void {
			bg.filters = [];
			removeEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
		}
		private function onKeyboardDown(e:KeyboardEvent):void {
			if (e.keyCode == 32) toggleState();
		}
		private function onStateChange():void {
			check.visible = state == "on";
		}
	}
}