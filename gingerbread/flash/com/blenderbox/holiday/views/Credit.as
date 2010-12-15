package com.blenderbox.holiday.views 
{
  import com.blenderbox.motion.TweenLite;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * @author cbrown
	 */
	public class Credit extends Sprite
	{
		
		public function Credit() 
		{
			hit.addEventListener(MouseEvent.ROLL_OUT, handleRollOut);
			hit.addEventListener(MouseEvent.ROLL_OVER, handleRollOver);
		}
		// event handlers
		private function handleRollOut(e:MouseEvent):void {
		  new TweenLite(creditLabel,.3,{autoAlpha:1});
		  new TweenLite(creditText,.3,{autoAlpha:0});
		  new TweenLite(bg,.3,{autoAlpha:0});
		}
		private function handleRollOver(e:MouseEvent):void {
		  new TweenLite(creditLabel,.3,{autoAlpha:0});
		  new TweenLite(creditText,.3,{autoAlpha:1});
		  new TweenLite(bg,.3,{autoAlpha:1});
		}
	}
	
}