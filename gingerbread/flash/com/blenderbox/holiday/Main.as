package com.blenderbox.holiday 
{
	import com.blenderbox.events.BaseButtonEvent;
	import com.blenderbox.events.SWFAddressEvent;
	import com.blenderbox.motion.TweenLite;
	import com.blenderbox.utils.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	/**
	 * @author cbrown
	 */
	public class Main extends MovieClip
	{
		private var card:Object;
		private var polaroids:Object;
		
		private const CARD_FILE:String = "../swfs/Card.swf";
		private const POLAROIDS_FILE:String = "../swfs/Polaroids.swf";
		
		public function Main() 
		{
			var c:CustomMenu = new CustomMenu(this);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			header.logo.enabled = false;
			
			onResize();
			addEventListeners();
			draw();
		}
		// privates
		private function addEventListeners():void {
			stage.addEventListener(Event.RESIZE, onResize);
			stage.addEventListener(Event.ACTIVATE, onResize);
			header.logo.addEventListener(BaseButtonEvent.HANDLE_RELEASE, onLogoRelease);
		}
		private function draw():void {
			TweenLite.to(header, 0.4, { alpha:1, delay:0.4 } );
			TweenLite.to(shadow, 0.4, { alpha:1, delay:0.4 } );
			TweenLite.to(bg, 1, { alpha:1, delay:0.6, onComplete:onDrawComplete } );
		}
		private function hidePolaroids():void {
			if (polaroids != null) polaroids.hide();
		}
		private function loadPolaroids():void {
			var loader:Loader = new Loader();
			loadBar.width = 0;
			loadBar.alpha = 1;
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPolaroidsLoadComplete);
			loader.load(new URLRequest(POLAROIDS_FILE));
			addChildAt(loader, 1);
		}
		private function showPolaroids():void {
			if (polaroids != null) polaroids.show();
			else loadPolaroids();
		}
		//event handlers
		private function onDrawComplete():void {
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.load(new URLRequest(CARD_FILE));
			addChildAt(loader, 1);
		}
		private function onLoadComplete(e:Event):void {
			card = e.target.content;
			TweenLite.to(loadBar, 0.3, { autoAlpha:0 } );
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, onSWFAddress);
			onSWFAddress();
		}
		private function onLoadProgress(e:ProgressEvent):void {
			TweenLite.to(loadBar, 0.2, { width:stage.stageWidth * (e.bytesLoaded / e.bytesTotal) + 5 } );
		}
		private function onLogoRelease(e:BaseButtonEvent):void {
			SWFAddress.setValue("/");
		}
		private function onPolaroidsLoadComplete(e:Event):void {
			TweenLite.to(loadBar, 0.3, { autoAlpha:0 } );
			polaroids = e.target.content;
			polaroids.init(card.imgDir, card.polaroidData);
			polaroids.show();
		}
		private function onResize(e:Event = null):void {
			headerBg.width = shadow.width = stage.stageWidth;
		}
		private function onSWFAddress(e:SWFAddressEvent = null):void {
			if (SWFAddress.getValue() == "/elves") showPolaroids();
			else hidePolaroids();
			header.logo.enabled = SWFAddress.getValue() != "/";
		}
	}
	
}