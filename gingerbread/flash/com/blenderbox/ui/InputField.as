package com.blenderbox.ui 
{
	import com.blenderbox.events.FormEvent;
	import com.blenderbox.motion.TweenLite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.text.*;
	
	/**
	 * @author cbrown
	 */
	public class InputField extends MovieClip
	{
		public var isEmail:Boolean = false;
		public var isRequired:Boolean = true;
		public var errorText:String = "";
		
		private var doesHaveError:Boolean = false;
		private var _defaultText:String = "";
		private var userText:String = "";
		
		private const ENTER:Number = 13;
		private const ERROR_COLOR:Number = 0xff0000;
		
		public function InputField() 
		{
			draw();
			valueTF.embedFonts = true;
			valueTF.addEventListener(FocusEvent.FOCUS_IN, onValueTFFocusIn);
			valueTF.addEventListener(FocusEvent.FOCUS_OUT, onValueTFFocusOut);
		}
		// publics
		public function get hasError():Boolean {
			if (!isRequired) return false;
			doesHaveError = value.replace(" ", "") == "";
			if (isEmail) doesHaveError = !isValidEmail(value);
			if (doesHaveError) {
				userText = value;
				valueTF.text = errorText;
				TweenLite.to(valueTF, 0.4, { tint:ERROR_COLOR } );
			}
			return doesHaveError;
		}
		public function get isMultiline():Boolean { return valueTF.multiline; }
		public function set isMultiline(boo:Boolean):void { valueTF.multiline = boo; }
		public function get value():String { return valueTF.text.replace(_defaultText, "").replace(errorText); }
		
		public function set defaultText(str:String) {
			_defaultText = str;
			valueTF.text = str;
		}
		public function set index(num:Number):void {
			valueTF.tabIndex = num;
		}
		public function set isNumbersOnly(boo:Boolean):void {
			if (boo) valueTF.restrict = "0-9";
		}
		// privates
		private function draw():void {
			if (scaleX != 1 || scaleY != 1) {
				var w:Number = this.width;
				var h:Number = this.height;
				isMultiline = scaleY != 1;
				scaleX = scaleY = 1;
				valueTF.width = w;
				valueTF.height = h;
			}
		}
		private function isValidEmail(email:String):Boolean {
			var emailExpression:RegExp = /^[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
			return emailExpression.test(email);
		}
		// event handlers
		private function onInputKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == ENTER) dispatchEvent(new FormEvent(FormEvent.SUBMIT));
		}
		private function onValueTFFocusIn(e:FocusEvent):void {
			if (!isMultiline) stage.addEventListener(KeyboardEvent.KEY_DOWN, onInputKeyDown);
			if (doesHaveError) {
				valueTF.text = userText;
				TweenLite.to(valueTF, 0.4, { tint:null } );
				doesHaveError = false;
			} else if (valueTF.text == _defaultText || valueTF.text == errorText) valueTF.text = "";
		}
		private function onValueTFFocusOut(e:FocusEvent):void {
			if (!isMultiline) stage.removeEventListener(KeyboardEvent.KEY_DOWN, onInputKeyDown);
			if (valueTF.text == "") valueTF.text = _defaultText;
		}
	}
}