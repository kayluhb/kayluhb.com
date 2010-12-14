package com.blenderbox.holiday 
{
	import com.adobe.images.PNGEncoder;
	import com.blenderbox.events.*;
	import com.blenderbox.holiday.events.HolidayEvent;
	import com.blenderbox.holiday.views.SnowStorm;
	import com.blenderbox.motion.easing.*;
	import com.blenderbox.motion.TweenLite;
	import com.blenderbox.net.XMLLoader;
	import com.blenderbox.utils.Env;
	import com.blenderbox.utils.SWFAddress;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.ui.Keyboard;
	import flash.ui.KeyLocation;
	import flash.utils.ByteArray;
	
	/**
	 * @author cbrown
	 */
	public class Card extends MovieClip
	{
		public var imgDir:String = "";
		public var polaroidData:XMLList;
		
		private var isDecorateDrawn:Boolean = false;
		private var lastState:String;
		private var nextState:String;
		private var state:String;
		
		private const BTN_TAR_W:Number = 6;
		private const CLEAR_W:Number = 103;
		private const PANEL_TAR_Y:Number = 134;
		private const UNDO_W:Number = 59;
		
		public function Card() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			drawUI();
		}
		// privates
		private function addEventListeners():void {
			stage.addEventListener(Event.RESIZE, onResize);
			stage.addEventListener(Event.ACTIVATE, onResize);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDown);
			
			decorationPanel.candySelector.addEventListener(NavEvent.BY_ID, onCandySelect);
			decorationPanel.sizeSelector.addEventListener(NavEvent.BY_ID, onSizeSelect);
			decorationPanel.colorSelector.addEventListener(NavEvent.BY_ID, onColorSelect);
			
			anotherCookieButton.addEventListener(	BaseButtonEvent.HANDLE_RELEASE, onAnotherCookieRelease);
			clearButton.addEventListener(			BaseButtonEvent.HANDLE_RELEASE, onClearRelease);
			decorateButton.addEventListener(		BaseButtonEvent.HANDLE_RELEASE, onDecorateRelease);
			emailButton.addEventListener(			BaseButtonEvent.HANDLE_RELEASE, onEmailRelease);
			polaroidPreview.addEventListener(		HolidayEvent.CLOSE_ELVES, onCloseElves);
			sendButton.addEventListener(			BaseButtonEvent.HANDLE_RELEASE, onSendRelease);
			startButton.addEventListener(			BaseButtonEvent.HANDLE_RELEASE, onStartRelease);
			undoButton.addEventListener(			BaseButtonEvent.HANDLE_RELEASE, onUndoRelease);
			
			anotherCookieButton.addEventListener(	BaseButtonEvent.HANDLE_OUT, onButtonOut);
			decorateButton.addEventListener(		BaseButtonEvent.HANDLE_OUT, onButtonOut);
			emailButton.addEventListener(			BaseButtonEvent.HANDLE_OUT, onButtonOut);
			sendButton.addEventListener(			BaseButtonEvent.HANDLE_OUT, onButtonOut);
			startButton.addEventListener(			BaseButtonEvent.HANDLE_OUT, onButtonOut);
			emailForm.emailButton.addEventListener(	BaseButtonEvent.HANDLE_OUT, onButtonOut);
			
			anotherCookieButton.addEventListener(	BaseButtonEvent.HANDLE_OVER, onButtonOver);
			decorateButton.addEventListener(		BaseButtonEvent.HANDLE_OVER, onButtonOver);
			emailButton.addEventListener(			BaseButtonEvent.HANDLE_OVER, onButtonOver);
			sendButton.addEventListener(			BaseButtonEvent.HANDLE_OVER, onButtonOver);
			startButton.addEventListener(			BaseButtonEvent.HANDLE_OVER, onButtonOver);
			emailForm.emailButton.addEventListener(	BaseButtonEvent.HANDLE_OVER, onButtonOver);
			
			clearButton.addEventListener(			BaseButtonEvent.HANDLE_OUT, onClearButtonOut);
			undoButton.addEventListener(			BaseButtonEvent.HANDLE_OUT, onUndoButtonOut);
			
			clearButton.addEventListener(			BaseButtonEvent.HANDLE_OVER, onClearButtonOver);
			undoButton.addEventListener(			BaseButtonEvent.HANDLE_OVER, onUndoButtonOver);
		}
		private function changeState(s:String):void {
			if (this.state != "elves") this.lastState = this.state;
			if (this.state != s) this.state = s;
			switch (this.state) {
				case "": drawHome(); break;
				case "decorate": 		drawDecorate(); break;
				case "elves": 			drawElves(); break;
				case "send": 			drawSend(); break;
				case "send-to-friend": 	drawSendToFriend(); break;
				case "thank-you": 		drawThankYou(); break;
			}
			if (this.state != "" && this.state != "elves") {
				polaroidPreview.collapse();
			}
		}
		private function drawHome():void {
			TweenLite.to(parchment, 1.2, { x:0, ease:Expo.easeOut, delay:0.6 } );
			TweenLite.to(parchment, 1.5, { y:65, ease:Expo.easeOut, delay:0.6, overwrite:false } );
			TweenLite.to(defaultCookie, 1, { rotation:0, x:208, y:186, ease:Expo.easeOut, delay:1 } );
			TweenLite.to(gingerbreadCookie, 1, { rotation:-90, x:0, y:-250, ease:Expo.easeOut } );
			tag.x = 56;
			tag.gotoAndStop(1);
			TweenLite.to(tag, 1.2, { rotation:0, y:0, ease:Back.easeOut, delay:1.5 } );
			TweenLite.to(homeCopy, 0.5, { autoAlpha:1, delay:1.2 } );
			TweenLite.to(startButton, 0.4, { autoAlpha:1, delay:1.5 } );
			polaroidPreview.show();
		}
		private function drawDecorate():void {
			TweenLite.to(parchment, 1.2, { x:0, ease:Expo.easeOut } );
			TweenLite.to(parchment, 1.5, { y:-65, ease:Expo.easeOut, overwrite:false } );
			TweenLite.to(gingerbreadCookie, 1, { rotation:0, x:124, y:92, ease:Expo.easeOut } );
			TweenLite.to(decorationPanel, 0.6, { y:stage.stageHeight - PANEL_TAR_Y, ease:Back.easeOut, delay:0.6, onComplete:onDecorateDrawn } );
			TweenLite.to(decorateCopy, 0.6, { autoAlpha:1, delay:1 } );
			TweenLite.to(sendButton, 0.6, { autoAlpha:1, delay:1.5 } );
		}
		private function drawElves():void {
			TweenLite.to(parchment, 1.5, { y:-parchment.height, ease:Expo.easeOut} );
			TweenLite.to(gingerbreadCookie, 1, { rotation:90, x:0, y:-268, ease:Expo.easeOut } );
			polaroidPreview.hide();
		}
		private function drawSend():void { 
			decorateButton.visible = true;
			TweenLite.to(parchment, 1.5, { y: -parchment.height, ease:Expo.easeOut } );
			TweenLite.to(gingerbreadCookie, 1, { rotation:-11, x:76, y:203, ease:Expo.easeOut } );
			TweenLite.to(sendCopy, 0.6, { autoAlpha:1, delay:0.4 } );
			TweenLite.to(emailButton, 0.6, { autoAlpha:1, delay:0.8 } );
		}
		private function drawSendToFriend():void {
			emailForm.enable();
			emailForm.reset();
			emailForm.visible = true;
			TweenLite.to(emailForm, 1.5, { y:153, ease:Expo.easeOut } );
			TweenLite.to(gingerbreadCookie, 1, { rotation: -11, x:2, y:225, ease:Expo.easeOut } );
			tag.x = 219;
			tag.gotoAndStop(2);
			TweenLite.to(tag, 1.2, { rotation:0, y:-10, ease:Back.easeOut, delay:0.8 } );
		}
		private function drawThankYou():void {
			TweenLite.to(gingerbreadCookie, 1, { rotation: -12, x:72, y:200, ease:Expo.easeOut } );
			TweenLite.to(thankYouCopy, 0.6, { autoAlpha:1, delay:0.2 } );
			TweenLite.to(anotherCookieButton, 0.6, { autoAlpha:1, delay:0.4 } );
		}
		private function drawUI():void {
			anotherCookieButton.visible = false;
			decorateCopy.visible = false;
			decorateButton.visible = false;
			emailButton.visible = false;
			emailForm.visible = false;
			homeCopy.visible = false;
			sendButton.visible = false;
			sendCopy.visible = false;
			startButton.visible = false;
			thankYouCopy.visible = false;
		}
		private function drawUndoButtons():void {
			undoButton.labelMask.width = undoButton.hit.width = 0;
			undoButton.labelMask.x = undoButton.hit.x = 59;
			undoButton.shadow.alpha = clearButton.shadow.alpha = 0;
			clearButton.labelMask.width = clearButton.hit.width = 0;
			clearButton.labelMask.x = clearButton.hit.x = 103;
			undoButton.x = 424;
			clearButton.x = 376;
			undoButton.hit.x = 59;
			clearButton.hit.x = 103;
			TweenLite.to(undoButton.hit, .8, { width:UNDO_W, x:0, ease:Expo.easeOut } );
			TweenLite.to(undoButton.labelMask, .8, { width:UNDO_W, x:0, ease:Expo.easeOut } );
			TweenLite.to(undoButton.shadow, .4, { autoAlpha:1 } );
			TweenLite.to(clearButton.hit, .8, { width:CLEAR_W, x:0, ease:Expo.easeOut, delay:0.2 } );
			TweenLite.to(clearButton.labelMask, .8, { width:CLEAR_W, x:0, ease:Expo.easeOut, delay:0.2 } );
			TweenLite.to(clearButton.shadow, .4, { autoAlpha:1 } );
		}
		private function hideHome():void {
			TweenLite.to(homeCopy, 0.4, { autoAlpha:0 } );
			TweenLite.to(defaultCookie, 1, { rotation:-90, x:0, y:-250, ease:Expo.easeOut } );
			TweenLite.to(startButton, 0.4, { autoAlpha:0, onComplete:changeState, onCompleteParams:[nextState] } );
			TweenLite.to(tag, 1, { y:-tag.height, ease:Expo.easeOut } );
		}
		private function hideElves():void {
			changeState(nextState);
		}
		private function hideDecorate():void {
			isDecorateDrawn = false;
			gingerbreadCookie.enabled = false;
			TweenLite.to(decorateCopy, 0.6, { autoAlpha:0 } );
			TweenLite.to(decorationPanel, 0.6, { y:stage.stageHeight + 50, ease:Back.easeOut } );
			TweenLite.to(sendButton, 0.6, { autoAlpha:0, onComplete:changeState, onCompleteParams:[nextState] } );
			
			TweenLite.to(undoButton.hit, .4, { width:0, x:55, ease:Expo.easeOut } );
			TweenLite.to(undoButton.shadow, .4, { autoAlpha:0 } );
			TweenLite.to(undoButton.labelMask, .4, { width:0, x:59, ease:Expo.easeOut } );
			TweenLite.to(clearButton.hit, .4, { width:0, x:98, ease:Expo.easeOut } );
			TweenLite.to(clearButton.shadow, .4, { autoAlpha:0 } );
			TweenLite.to(clearButton.labelMask, .4, { width:0, x:103, ease:Expo.easeOut } );
		}
		private function hideSend():void {
			decorateButton.visible = false;
			TweenLite.to(sendCopy, 0.6, { autoAlpha:0 } );
			TweenLite.to(emailButton, 0.6, { autoAlpha:0, onComplete:changeState, onCompleteParams:[nextState] } );
		}
		private function hideSendToFriend():void { 
			TweenLite.to(emailForm, 1, { y:-emailForm.height, ease:Expo.easeOut, onComplete:onFormOut } );
			TweenLite.to(tag, 1.2, { rotation:0, y:-tag.height, ease:Back.easeOut, onComplete:changeState, onCompleteParams:[nextState] } );
		}
		private function hideThankYou():void {
			TweenLite.to(thankYouCopy, 0.6, { autoAlpha:0 } );
			TweenLite.to(anotherCookieButton, 0.6, { autoAlpha:0, onComplete:changeState, onCompleteParams:[nextState] } );
		}
		private function undoState(s:String):void {
			nextState = s;
			trace("undo state", nextState)
			switch (state) {
				case "": 				hideHome(); break;
				case "elves": 			hideElves(); break;
				case "decorate": 		hideDecorate(); break;
				case "send": 			hideSend(); break;
				case "send-to-friend": 	hideSendToFriend(); break;
				case "thank-you": 		hideThankYou(); break;
			}
		}
		
		// event handlers
		private function onAddedToStage(e:Event):void {
			
			var xmlLoader:XMLLoader = new XMLLoader();
      xmlLoader.addEventListener(XmlLoadEvent.ON_LOAD, onXmlLoad);
      var xmlPath:String = Env.isOnline ? "/gingerbread/xml/Main.xml" : "../xml/Main.xml";
      xmlLoader.load(xmlPath);
			
			addEventListeners();
			onResize();
		}
		private function onAnotherCookieRelease(e:BaseButtonEvent):void {
			gingerbreadCookie.clearAll();
			SWFAddress.setValue("/decorate");
		}
		private function onButtonOut(e:BaseButtonEvent):void {
			TweenLite.to(e.target.hit, 0.5, { tint:0x335BB2 } );
		}
		private function onButtonOver(e:BaseButtonEvent):void {
			TweenLite.to(e.target.hit, 0.3, { tint:0x28478b } );
		}
		private function onCandySelect(e:NavEvent):void {
			gingerbreadCookie.addCandy(e.id);
		}
		private function onClearButtonOut(e:BaseButtonEvent):void {
			TweenLite.to(e.target.hit, .8, { width:CLEAR_W, x:0, ease:Expo.easeOut } );
		}
		private function onClearButtonOver(e:BaseButtonEvent):void {
			TweenLite.to(e.target.hit, .8, { width:CLEAR_W + BTN_TAR_W, x:-BTN_TAR_W, ease:Expo.easeOut } );
		}
		private function onClearRelease(e:BaseButtonEvent):void {
			gingerbreadCookie.clearAll();
		}
		private function onCloseElves(e:HolidayEvent):void {
			if (lastState == null) lastState = "";
			SWFAddress.setValue("/" + lastState);
		}
		private function onColorSelect(e:NavEvent):void {
			gingerbreadCookie.lineColor = e.id;
			gingerbreadCookie.tipColor = e.id;
			decorationPanel.sizeSelector.lineColor = e.id;
		}
		private function onDecorateDrawn():void {
			isDecorateDrawn = true;
			drawUndoButtons();
			gingerbreadCookie.enabled = true;
		}
		private function onFormOut():void {
			emailForm.visible = false;
		}
		private function onStageKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == 40 && e.shiftKey) {
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDown);
				addChild(new SnowStorm());
			}
		}
		private function onResize(e:Event = null):void {
			if (isDecorateDrawn) decorationPanel.y = int(stage.stageHeight - PANEL_TAR_Y);
			else decorationPanel.y = stage.stageHeight + 50;
			decorationPanel.x = int(stage.stageWidth/2-decorationPanel.bg.width/2);
		}
		private function onSizeSelect(e:NavEvent):void {
			gingerbreadCookie.lineWidth = e.id;
		}
		private function onSWFAddress(e:SWFAddressEvent = null):void {
			var nav:Array = e != null ? e.pathNames : [];
			var s:String = nav[0] != null ? nav[0] : "";
			if (state != s) {
				if (state == null) changeState(s);
				else undoState(s);
			}
			trace(e, s);
		}
		private function onUndoButtonOut(e:BaseButtonEvent):void {
			TweenLite.to(e.target.hit, .8, { width:UNDO_W, x:0, ease:Expo.easeOut } );
		}
		private function onUndoButtonOver(e:BaseButtonEvent):void {
			TweenLite.to(e.target.hit, .8, { width:UNDO_W + BTN_TAR_W, x:-BTN_TAR_W, ease:Expo.easeOut } );
		}
		private function onUndoRelease(e:BaseButtonEvent):void {
			gingerbreadCookie.clearLast();
		}
		private function onXmlLoad(e:XmlLoadEvent):void {
			var data:XML = e.xml;
			imgDir = data.@imgFolder;
			polaroidData = data.polaroid;
			decorationPanel.sizeSelector.init(data.lineWidth);
			decorationPanel.colorSelector.init(data.lineColor);
			decorationPanel.candySelector.init(data.candy);
			
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, onSWFAddress);
			onSWFAddress();
		}
		// nav handlers
		private function onDecorateRelease(e:BaseButtonEvent):void { 	SWFAddress.setValue("/decorate"); }
		private function onEmailRelease(e:BaseButtonEvent):void {		SWFAddress.setValue("/send-to-friend"); }
		private function onSendRelease(e:BaseButtonEvent):void { 		SWFAddress.setValue("/send"); }
		private function onStartRelease(e:BaseButtonEvent):void { 		SWFAddress.setValue("/decorate"); }
	}
	
}