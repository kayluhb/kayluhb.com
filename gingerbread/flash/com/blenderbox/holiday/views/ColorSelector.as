package com.blenderbox.holiday.views 
{
	import com.blenderbox.events.*;
	import com.blenderbox.motion.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	
	/**
	 * @author cbrown
	 */
	public class ColorSelector extends Sprite
	{
		private var buttons:Array = [];
		private var curButtonId:Number = 0;
		
		private const ALPHA_OFF:Number = 1;
		private const ALPHA_ON:Number = 0;
		private const TAR_Y:Number = 30;
		
		public function ColorSelector() 
		{
			
		}
		// publics
		public function init(data:XMLList):void {
			for (var i:Number = 0; i < data.length(); ++i) {
				var button:ColorSelectorButton = new ColorSelectorButton();
				var target:MovieClip = button.fillHolder.fill;
				var ctf:ColorTransform = target.transform.colorTransform;
				ctf.color = data[i];
				target.transform.colorTransform = ctf;
				button.y = TAR_Y * i;
				button.id = data[i];
				button.addEventListener(BaseButtonEvent.HANDLE_DISABLED, onButtonDisabled);
				button.addEventListener(BaseButtonEvent.HANDLE_ENABLED, onButtonEnabled);
				button.addEventListener(BaseButtonEvent.HANDLE_RELEASE, onButtonRelease);
				addChild(button);
				buttons[buttons.length] = button;
			}
			disableCurrent();
			dispatchEvent(new NavEvent(NavEvent.BY_ID, buttons[curButtonId].id));
		}
		// privates
		private function disableCurrent():void {
			buttons[curButtonId].enabled = false;
		}
		private function enableCurrent():void {
			buttons[curButtonId].enabled = true;
		}
		// event handlers
		private function onButtonDisabled(e:BaseButtonEvent):void {
			TweenLite.to(e.target.bg, 0.4, { alpha:ALPHA_OFF } );
		}
		private function onButtonEnabled(e:BaseButtonEvent):void {
			TweenLite.to(e.target.bg, 0.4, { alpha:ALPHA_ON } );
		}
		private function onButtonRelease(e:BaseButtonEvent):void {
			enableCurrent();
			dispatchEvent(new NavEvent(NavEvent.BY_ID, e.id));
			curButtonId = getChildIndex(e.target as ColorSelectorButton);
			disableCurrent();
		}
	}
	
}