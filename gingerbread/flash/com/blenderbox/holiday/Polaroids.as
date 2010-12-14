package com.blenderbox.holiday 
{
	import com.blenderbox.events.ImageEvent;
	import com.blenderbox.holiday.views.Polaroid;
	import com.blenderbox.motion.easing.Expo;
	import com.blenderbox.motion.TweenLite;
	import com.blenderbox.utils.*;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * @author cbrown
	 */
	public class Polaroids extends MovieClip
	{
		private var loadPolaroids:Array = [];
		private var polaroids:Array = [];
		private var isShowing:Boolean = false;
		private var imgDir:String = "";
		
		public function Polaroids() {
			elvesCopy.visible = false;
		}
		public function hide():void {
			if (isShowing) {
				isShowing = false;
				aniOut();
			}
		}
		public function init(imgDir:String, data:XMLList):void {
			this.imgDir = imgDir;
			for (var i:Number = 0; i < data.length(); ++i) {
				var p:Polaroid = new Polaroid(i, data[i].@src, data[i]);
				var dir = Math.random() > .5 ? 1 : -1;
				p.addEventListener(ImageEvent.ON_LOAD, loadPolaroid);
				p.rotation = MathUtils.getRandomInt(3, 0) * 15 * dir;
				p.x = MathUtils.getRandomInt(stage.stageWidth - 100, 100);
				p.y = -p.height - MathUtils.getRandomInt(100, 0);
				polaroids.push(p);
				loadPolaroids.push(p);
			}
			addPolaroids();
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
			if (isShowing) aniIn();
			loadPolaroid();
		}
		public function show():void {
			if (!isShowing) {
				isShowing = true;
				visible = true;
				aniIn();
			}
		}
		// privates
		private function addPolaroids():void {
			polaroids = ArrayUtils.shuffle(polaroids);
			var ids:String = "";
			for (var i:Number = 0; i < polaroids.length; ++i) {
				ids += polaroids[i].id+", ";
				addChild(polaroids[i]);
			}
		}
		private function aniIn():void {
			setChildIndex(elvesCopy, numChildren - 1);
			TweenLite.to(elvesCopy, 0.5, { autoAlpha:1, delay:.8 } );
			for (var i:Number = 0; i < polaroids.length; ++i) {
				var p:Polaroid = polaroids[i];
				TweenLite.to(p, .8, { rotation:p.defaultAngle, x:p.defaultX, y:p.defaultY, ease:Expo.easeOut, delay:1 + 0.1 * i } );
			}
		}
		private function aniOut():void {
			TweenLite.to(elvesCopy, 0.5, { autoAlpha:0 } );
			for (var i:Number = 0; i < polaroids.length; ++i) {
				var p:Polaroid = polaroids[i];
				var aniObj:Object = { x:MathUtils.getRandomInt(stage.stageWidth - 100, 100), y: -p.height - MathUtils.getRandomInt(100, 0), ease:Expo.easeOut };
				if (i == numChildren - 1) aniObj.onComplete = onAniComplete;
				p.stopIt();
				TweenLite.to(p, .8, aniObj );
			}
		}
		private function loadPolaroid(e:ImageEvent = null):void {
			if (loadPolaroids.length > 0) {
				var p:Polaroid = loadPolaroids.pop();
				if (loadPolaroids.length == polaroids.length - 1) setChildIndex(p, numChildren - 2);
				p.load(imgDir);
			}
		}
		// event handlers
		private function onAniComplete():void {
			this.visible = false;
		}
		private function onResize(e:Event = null):void {
			elvesCopy.x = int(stage.stageWidth - elvesCopy.width - 20);
			elvesCopy.y = int(stage.stageHeight - elvesCopy.height - 26);
			for (var i:Number = 0; i < polaroids.length; ++i) polaroids[i].setDefaults();
			if (isShowing) aniIn();
		}
	}
}