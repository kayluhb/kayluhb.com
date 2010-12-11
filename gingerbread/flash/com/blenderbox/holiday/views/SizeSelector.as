package com.blenderbox.holiday.views 
{
	import com.blenderbox.events.*;
	import com.blenderbox.motion.TweenLite;
	import flash.display.*;
	import flash.filters.BevelFilter;
	import flash.geom.ColorTransform;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * @author cbrown
	 */ 
	public class SizeSelector extends Sprite
	{
		private var buttons:Array = [];
		private var bevelFilter:BevelFilter = new BevelFilter(5, 30, 0xffffff, .75, 0x000000, .1, 4, 4, .6, 2);
		private var curButtonId:Number = 0;
		
		private const ALPHA_OFF:Number = 1;
		private const ALPHA_ON:Number = 0;
		private const TAR_X:Number = 6;
		private const TAR_Y:Number = 10;
		
		public function SizeSelector() 
		{
			
		}
		// publics
		public function set lineColor(col:Number):void {
			for (var i:Number = 0; i < buttons.length; ++i) {
				var target:MovieClip = buttons[i].icon.fill;
				var ctf:ColorTransform = target.transform.colorTransform;
				ctf.color = col;
				target.transform.colorTransform = ctf;
			}
		}
		public function init(data:XMLList):void {
			for (var i:Number = 0; i < data.length(); ++i) {
				var id:Number = data[i];
				var bWidth:Number = data[i].@border;
				var half:Number = id * .5;
				var button:SizeSelectorButton = new SizeSelectorButton();
				var border:Shape = new Shape();
				border.graphics.lineStyle(bWidth, 0x817168, 1);
				border.graphics.drawCircle(half, half, half + bWidth / 2);
				border.graphics.endFill();
				border.filters = [bevelFilter];
				button.addChildAt(border, 1);
				
				button.hit.height = button.hit.width = button.icon.width = button.icon.height = id;
				button.x = data[i].@x;
				button.y = data[i].@y;
				button.id = id;
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
			TweenLite.to(e.target.icon, 0.4, { alpha:ALPHA_OFF } );
		}
		private function onButtonEnabled(e:BaseButtonEvent):void {
			TweenLite.to(e.target.icon, 0.4, { alpha:ALPHA_ON } );
		}
		private function onButtonRelease(e:BaseButtonEvent):void {
			enableCurrent();
			dispatchEvent(new NavEvent(NavEvent.BY_ID, e.id));
			curButtonId = getChildIndex(e.target as SizeSelectorButton);
			disableCurrent();
		}
	}
	
}