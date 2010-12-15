package com.blenderbox.holiday.views 
{
	import com.blenderbox.holiday.events.HolidayEvent;
	import com.blenderbox.motion.easing.Expo;
	import com.blenderbox.motion.TweenLite;
	import com.blenderbox.utils.SWFAddress;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * @author cbrown
	 */
	public class PolaroidPreview extends MovieClip
	{
		private var isCollapsed:Boolean = false;
		private var isHidden:Boolean = false;
		private var dbr:Number = 0;
		private var dbx:Number = 0;
		private var dby:Number = 0;
		
		private const TAR_X:Number = 540;
		
		public function PolaroidPreview() 
		{
			buttonMode = true;
			focusRect = false;
			dbr = int(bottomCard.rotation);
			dbx = int(bottomCard.x);
			dby = int(bottomCard.y);
			bottomCard.icon.visible = bottomCard.labelMC.visible = bottomCard.backLabelMC.visible = topCard.icon.visible = topCard.backLabelMC.visible = false;
			bottomCard.hit.addEventListener(MouseEvent.MOUSE_OUT, onPreviewMouseOut);
			bottomCard.hit.addEventListener(MouseEvent.MOUSE_OVER, onPreviewMouseOver);
			bottomCard.hit.addEventListener(MouseEvent.MOUSE_UP, onPreviewMouseUp);
			topCard.hit.addEventListener(MouseEvent.MOUSE_OUT, onPreviewMouseOut);
			topCard.hit.addEventListener(MouseEvent.MOUSE_OVER, onPreviewMouseOver);
			topCard.hit.addEventListener(MouseEvent.MOUSE_UP, onPreviewMouseUp);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		// publics
		public function collapse():void {
			isCollapsed = true;
			isHidden = false;
			resetIcons();
			TweenLite.killTweensOf(bottomCard);
			TweenLite.killTweensOf(topCard);
			TweenLite.to(bottomCard, 0.5, { rotation:dbr, x:dbx, y:dby } );
			TweenLite.to(topCard, 0.5, { rotation: -20, x:276, y:27 } );
		}
		public function hide():void {
			isCollapsed = false;
			isHidden = true;
			changeIcons();
			TweenLite.to(bottomCard, 0.5, { rotation:dbr, x:dbx, y:dby } );
			TweenLite.to(topCard, 0.5, { rotation: -20, x:287, y:0 } );
		}
		public function show():void {
			isCollapsed = false;
			isHidden = false;
			resetIcons();
			TweenLite.to(bottomCard, 1, { rotation:-19, x:129, y:44, ease:Expo.easeOut, delay:1.2 } );
			TweenLite.to(topCard, 1, { rotation:-11, x:220, y:86, ease:Expo.easeOut, delay:1.3 } );
		}
		// privates
		private function changeIcons():void {
			if (topCard.labelMC.alpha > 0) {
				TweenLite.to(topCard.labelMC, 0.4, { autoAlpha:0 } );
				TweenLite.to(topCard.icon, 0.4, { autoAlpha:1 } );
				TweenLite.to(topCard.backLabelMC, 0.4, { autoAlpha:1 } );
			}
		}
		private function peekABoo():void {
			TweenLite.killTweensOf(bottomCard);
			TweenLite.killTweensOf(topCard);
			TweenLite.to(bottomCard, .8, { rotation:-19, x:129, y:44, ease:Expo.easeOut, delay:0.1 } );
			TweenLite.to(topCard, .8, { rotation:-11, x:220, y:86, ease:Expo.easeOut, delay:0.1 } );
		}
		private function peekABooHidden():void {
			TweenLite.to(topCard, 0.8, { x:240, y:40, ease:Expo.easeOut } );
		}
		private function resetIcons():void {
			if (topCard.icon.alpha > 0) {
				TweenLite.to(topCard.labelMC, 0.4, { autoAlpha:1 } );
				TweenLite.to(topCard.icon, 0.4, { autoAlpha:0 } );
				TweenLite.to(topCard.backLabelMC, 0.4, { autoAlpha:0 } );
			}
		}
		private function rollOutShowing():void {
			TweenLite.to(bottomCard, 1, { rotation:-19, x:129, y:44, ease:Expo.easeOut } );
			TweenLite.to(topCard, 1, { rotation:-11, x:220, y:86, ease:Expo.easeOut } );
		}
		private function rollOverShowing():void {
			TweenLite.to(bottomCard, 1, { x:134, y:39, ease:Expo.easeOut } );
			TweenLite.to(topCard, 1, { x:225, y:81, ease:Expo.easeOut } );
		}
		// event handlers
		private function onAddedToStage(e:Event):void {
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}
		private function onPreviewMouseOut(e:MouseEvent):void {
			if (isCollapsed) { 
				collapse();
			} else if (isHidden) {
				hide();
			} else {
				rollOutShowing();
			}
		}
		private function onPreviewMouseOver(e:MouseEvent):void {
			if (isCollapsed) {
				peekABoo();
			} else if (isHidden) {
				peekABooHidden();
			} else {
				rollOverShowing();
			}
		}
		private function onPreviewMouseUp(e:MouseEvent):void {
			if (SWFAddress.getValue() != "/elves") SWFAddress.setValue("/elves");
			else dispatchEvent(new HolidayEvent(HolidayEvent.CLOSE_ELVES));
		}
		private function onResize(e:Event = null):void {
			this.x = stage.stageWidth - TAR_X;
		}
	}
}