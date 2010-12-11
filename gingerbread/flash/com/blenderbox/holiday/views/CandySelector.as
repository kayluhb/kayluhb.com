package com.blenderbox.holiday.views 
{
	import com.blenderbox.events.BaseButtonEvent;
	import com.blenderbox.events.NavEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * @author cbrown
	 */
	public class CandySelector extends MovieClip
	{
		private const TAR_X:Number = 129;
		
		public function CandySelector() 
		{
			
		}
		// publics
		public function init(data:XMLList):void {
			for (var i:Number = 0; i < data.length(); ++i) {
				var button:CandySelectorButton = new CandySelectorButton();
				button.id = i;
				button.icon.gotoAndStop(i + 1);
				button.addEventListener(BaseButtonEvent.HANDLE_PRESS, onCandyPress);
				button.x = TAR_X * i;
				addChild(button);
			}
		}
		// privates
		// event handlers
		private function onCandyPress(e:BaseButtonEvent):void {
			dispatchEvent(new NavEvent(NavEvent.BY_ID, e.id));
		}
	}
	
}