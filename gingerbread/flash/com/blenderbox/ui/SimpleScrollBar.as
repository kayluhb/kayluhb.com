/**
* @author cbrown
*/
package com.blenderbox.ui
{
	import com.blenderbox.motion.TweenLite;
	import com.blenderbox.events.ScrollingEvent;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class SimpleScrollBar extends Sprite {
		
		private var __min:Number;
		private var __max:Number;
		private var __value:Number = 0;
		private var tmp_yoffset:Number;
		
		public function SimpleScrollBar() {
			scaleX = scaleY = 1;
			track.height = height;
			thumb.buttonMode = true;
			thumb.addEventListener(MouseEvent.MOUSE_DOWN, onBeginDrag);
			thumb.addEventListener(MouseEvent.MOUSE_UP, onEndDrag);
			track.addEventListener(MouseEvent.CLICK, onTrackClick);
			setRange(0, 0);
			draw();
		}
		//getter/setters:
		public function get min():Number { return __min; }
		public function get max():Number { return __max; }
		public function get value():Number { return __value; }
		public function set value(p_value:Number):void { setValue(p_value); }
	
		// publics
		public function setRange(p_min:Number, p_max:Number):void {
			__min = p_min;
			__max = p_max;
			if (__max <= __min) {
				visible = false;
				alpha = 0;
			} else {
				TweenLite.to(this, 0.2, { autoAlpha:1 } );
				draw();
			}
		}
		public function setValue(p_value:Number):void {
			__value = Math.min(__max, Math.max(__min, p_value));
			draw();
			dispatchEvent(new ScrollingEvent(ScrollingEvent.ON_CHANGE));
		}
		// privates
		private function calculateValue():void {
			__value = Math.min(__max, Math.max(__min, thumb.y / (height - thumb.height) * (__max - __min) + __min));
			dispatchEvent(new ScrollingEvent(ScrollingEvent.ON_CHANGE));
		}
		private function draw():void {
			thumb.y = (height - thumb.height) * (__value - __min) / (__max - __min);
		}
		//event handlers
		private function onBeginDrag(e:MouseEvent):void {
			thumb.parent.stage.addEventListener(MouseEvent.MOUSE_UP, onEndDrag);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onDoDrag);
			tmp_yoffset = thumb.mouseY * thumb.scaleY;
		}
		private function onDoDrag(e:MouseEvent):void {
			thumb.y = Math.max(0, Math.min(height - thumb.height, mouseY - tmp_yoffset));
			calculateValue();
		}
		private function onEndDrag(e:MouseEvent):void {
			thumb.parent.stage.removeEventListener(MouseEvent.MOUSE_UP, onEndDrag);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDoDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onEndDrag);
		}
		private function onTrackClick(e:MouseEvent):void {
			thumb.y = Math.max(0, Math.min(height - thumb.height, mouseY - thumb.height / 2));
			calculateValue();
		}
	}
}