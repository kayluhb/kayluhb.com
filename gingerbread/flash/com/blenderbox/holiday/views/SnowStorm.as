package com.blenderbox.holiday.views 
{
	import com.blenderbox.holiday.views.SnowFlake;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	/**
	 * @author cbrown
	 */
	public class SnowStorm extends MovieClip
	{
		public var viewWidth:Number;
		public var viewHeight:Number;
		
		private const NUM_FLAKES:Number = 300;
		
		public function SnowStorm()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		// privates
		private function addFlakes():void {
			for (var i:Number = 0; i < NUM_FLAKES; i++) {
				var flake = new SnowFlake();
				addChild(flake);
			}
		}
		// event handlers
		private function onAddedToStage(e:Event):void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
			addFlakes();
		}
		private function onResize(e:Event = null):void {
			viewWidth = stage.stageWidth;
			viewHeight = stage.stageHeight;
		}
	}
	
}