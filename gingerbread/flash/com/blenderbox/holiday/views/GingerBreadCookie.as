package com.blenderbox.holiday.views 
{
	import com.blenderbox.motion.easing.Back;
	import com.blenderbox.motion.easing.Quad;
	import com.blenderbox.motion.TweenLite;
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.ColorTransform;
	import flash.ui.Mouse;
	
	/**
	 * @author cbrown
	 */
	public class GingerBreadCookie extends Sprite
	{
		public var lineColor:Number = 0xffffff;
		public var lineWidth:Number = 4;
		
		private var candy:Candy;
		private var line:Shape;
		
		private var isEnabled:Boolean = false;
		private var isPressing:Boolean = false;
		private var tipIsShowing:Boolean = false;
		private var bevelFilter:BevelFilter = new BevelFilter(4, 45, 0xffffff, 1, 0x000000, 1, 4, 4, .6, 2);
		private var dropFilter:DropShadowFilter = new DropShadowFilter(2, 45, 0, 1, 6, 6, .35, 2);
		private var drawData:String = "";
		
		public function GingerBreadCookie() 
		{
			tip.visible = false;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		// publics
		public function get enabled():Boolean {
			return isEnabled;
		}
		public function set enabled(boo:Boolean):void {
			if (isEnabled != boo) isEnabled = boo;
			if (isEnabled) enable();
			else disable();
		}
		
		public function get overCookie():Boolean { return cookie.hitTestPoint(stage.mouseX, stage.mouseY, true); }
		
		public function set tipColor(n:Number):void {
			var ctf:ColorTransform = tip.dab.dot.transform.colorTransform;
			ctf.color = n;
			tip.dab.dot.transform.colorTransform = ctf;
		}
		public function addCandy(id:Number):void {
			candy = new Candy();
			candy.filters = [dropFilter, bevelFilter];
			candy.icon.gotoAndStop(id + 1);
			candy.x = mouseX;
			candy.y = mouseY;
			addChild(candy);
			stage.addEventListener(MouseEvent.MOUSE_UP, onCandyDrop);
		}
		public function clearAll():void {
			while (icing.numChildren > 0) { icing.removeChildAt(0); }
		}
		public function clearLast():void {
			if (icing.numChildren > 0) icing.removeChildAt(icing.numChildren - 1);
		}
		// privates
		private function aniCandyToCookie(target:Candy):void {
			TweenLite.to(target, 0.2, { scaleX:1, scaleY:1, ease:Quad.easeOut } );
		}
		private function disable():void {
			hit.removeEventListener(MouseEvent.MOUSE_DOWN, onCookieMouseDown);
			hit.removeEventListener(MouseEvent.MOUSE_OUT, onCookieMouseOut);
			hit.removeEventListener(MouseEvent.MOUSE_OVER, onCookieMouseOver);
			hideCursor(true);
		}
		private function dropCandy():void {
			TweenLite.to(candy, 0.4, { scaleX:0, scaleY:0, onComplete:removeCandy, onCompleteParams:[candy], ease:Back.easeIn } );
			candy = null;
		}
		private function dropCandyOnCookie():void {
			removeChild(candy);
			icing.addChild(candy);
			TweenLite.to(candy, 0.2, { scaleX:1.2, scaleY:1.2, onComplete:aniCandyToCookie, onCompleteParams:[candy] } );
			candy = null;
		}
		private function enable():void {
			showCursor();
			hit.addEventListener(MouseEvent.MOUSE_DOWN, onCookieMouseDown);
			hit.addEventListener(MouseEvent.MOUSE_OUT, onCookieMouseOut);
			hit.addEventListener(MouseEvent.MOUSE_OVER, onCookieMouseOver);
		}
		private function hideCursor(forceIt:Boolean = false):void {
			if ((candy == null && tipIsShowing && !overCookie) || forceIt) {
				tipIsShowing = false;
				TweenLite.to(tip, 0.4, { autoAlpha:0 } );
				Mouse.show();
			}
		}
		private function removeCandy(c:Candy):void {
			removeChild(c);
		}
		private function showCursor():void {
			if (candy == null && !tipIsShowing && overCookie) {
				tipIsShowing = true;
				TweenLite.to(tip, 0.2, { autoAlpha:1 } );
				Mouse.hide();
			}
		}
		// event handlers
		private function onAddedToStage(e:Event):void {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseOver);
		}
		private function onCandyDrop(e:MouseEvent):void {
			if (candy) {
				if (overCookie) dropCandyOnCookie();
				else dropCandy();
			}
			stage.removeEventListener(MouseEvent.MOUSE_UP, onCandyDrop);
		}
		private function onCookieMouseDown(e:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			isPressing = true;
			
			line = new Shape();
			line.filters = [bevelFilter, dropFilter];
			line.graphics.lineStyle(lineWidth, lineColor);
			line.graphics.moveTo(e.localX, e.localY);
			icing.addChild(line);
			
			drawData += "#" + e.localX + ","  + e.localY;
		}
		private function onCookieMouseOut(e:MouseEvent):void {
			hideCursor();
		}
		private function onCookieMouseOver(e:MouseEvent):void {
			showCursor();
		}
		private function onStageMouseOver(e:MouseEvent):void {
			if(overCookie){
				tip.x = mouseX - 1;
				tip.y = mouseY - 1;
				
				if (line && isPressing && mouseX > 0 && mouseY > 0) {
					line.graphics.lineTo(mouseX, mouseY);
					drawData += ("," + mouseX + ","  + mouseY);
				}
			}
			if (candy) {
				candy.x = mouseX;
				candy.y = mouseY;
			}
		}
		private function onStageMouseUp(e:MouseEvent):void {
			isPressing = false;
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			hideCursor();
		}
	}
}