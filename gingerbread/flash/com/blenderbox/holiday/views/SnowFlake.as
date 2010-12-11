package com.blenderbox.holiday.views 
{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.filters.BlurFilter;
	import flash.utils.Timer;
	
	/**
	 * @author cbrown
	 */
	public class SnowFlake extends MovieClip 
	{
		private var storm:SnowStorm;
		
		private var drift:Number;
		private var speedMultiplier:Number = 5;
		private var speedVariMultiplier:Number = 10;
		private var speed:Number = Math.random() * speedMultiplier;
		private var speedVariation = Math.random() * speedVariMultiplier + 1;
		private var timer:Timer;
		
		private const TIMER_POLL:Number = 40;
		
		public function SnowFlake() 
		{
			timer = new Timer(TIMER_POLL);
			timer.addEventListener(TimerEvent.TIMER, onTimerFire);
			
			setSpeed(speed);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}	
		// privates
		private function getDrift():void {
			var driftDirection:Number = Math.random() * 10;
			
			drift = Math.random() * 3;
			if (driftDirection < 5) {
				drift *= -1;
			}
		}
		private function readyFlake():void {
			getDrift();
			
			this.y = Math.random() * storm.viewHeight * -1;
			this.x = Math.random() * storm.viewWidth;

			var bf:BlurFilter = new BlurFilter(drift * 2, speed / 2, 2);
			this.filters = [bf];
			
			if (speed / 2 < speedVariation) {
				this.scaleX = this.scaleY = .5;
			}
		}
		private function setSpeed(n:Number):void {
			this.speed = (n * speedVariation) + 1;
		}
		private function startMoving():void{
			timer.start();
		}
		// event handlers
		private function onAddedToStage(e:Event):void {
			storm = this.parent as SnowStorm;
			readyFlake();
			startMoving();
		}
		private function onTimerFire(e:TimerEvent):void {
			this.y += speed;
			this.x += drift;
			
			if (this.y > storm.viewHeight || this.x < 0 || this.x > storm.viewWidth) {
				readyFlake();
			}
		}
	}
}