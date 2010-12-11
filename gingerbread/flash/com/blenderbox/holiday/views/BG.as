package com.blenderbox.holiday.views 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * @author cbrown
	 */
	public class BG extends Sprite
	{
		
		public function BG() 
		{
			onResize();
			stage.addEventListener(Event.RESIZE, onResize);
		}
		// event handlers
		private function onResize(e:Event = null):void {
			graphics.beginBitmapFill(new BGImage(0, 0));
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
		}
	}
	
}