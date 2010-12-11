package com.blenderbox.ui
{
	import com.blenderbox.events.ScrollingEvent;
	import com.blenderbox.ui.SimpleScrollBar
	import com.blenderbox.utils.MacMouseWheel;
	import flash.display.*;
	import flash.events.MouseEvent;
	
	/**
	* @author cbrown
	*/
	public class ClipScroller {
		
		private var scrollBar:SimpleScrollBar;
		
		private var content:Sprite;
		private var mask:MovieClip;
		
		private const TAR_SY:Number = 0.25;
		
		public function ClipScroller(scrollBar:SimpleScrollBar, content:Sprite, mask:MovieClip) {
			this.scrollBar = scrollBar;
			this.content = content;
			this.mask = mask;
			init();
		}
		// publics
		public function destroy(){
			content.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			content.mask = null;
			destroyInstance(this);
		}
		public function refresh():void {
			var ch:Number = content.height;
			scrollBar.setRange(0, Math.max(0, ch - mask.height));
			scrollBar.value = 0;
			onChange();
		}
		//privates
		private function init():void {
			MacMouseWheel.setup(this.content.stage);
			scrollBar.value = 0;
			content.mask = mask;
			scrollBar.addEventListener(ScrollingEvent.ON_CHANGE, onChange);
			content.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			refresh();
		}
		private static function destroyInstance(instance:ClipScroller):void {
			instance = null;
		}
		//event handlers
		private function onChange(e:ScrollingEvent = null):void {
			content.y = Math.round(mask.y - scrollBar.value);
		}
		private function onMouseWheel(event:MouseEvent) {
			var overContent:Boolean = content.hitTestPoint(content.stage.mouseX, content.stage.mouseY, false);
			var tar:Number = (event.delta > 0 ? -1 : 1) * mask.height * TAR_SY;
			if (overContent) scrollBar.value += tar;
		}
	}
}