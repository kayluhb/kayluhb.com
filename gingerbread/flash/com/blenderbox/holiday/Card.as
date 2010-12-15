package com.blenderbox.holiday 
{
	import com.adobe.images.PNGEncoder;
	import com.blenderbox.events.*;
	import com.blenderbox.holiday.events.HolidayEvent;
	import com.blenderbox.holiday.models.FormData;
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
	import flash.xml.*;
	
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
			
			anotherCookieButton.addEventListener(BaseButtonEvent.HANDLE_RELEASE, onAnotherCookieRelease);
			clearButton.addEventListener(BaseButtonEvent.HANDLE_RELEASE, onClearRelease);
			decorateButton.addEventListener(BaseButtonEvent.HANDLE_RELEASE, onDecorateRelease);
			polaroidPreview.addEventListener(HolidayEvent.CLOSE_ELVES, onCloseElves);
			sendButton.addEventListener(BaseButtonEvent.HANDLE_RELEASE, onSendRelease);
			startButton.addEventListener(BaseButtonEvent.HANDLE_RELEASE, onStartRelease);
			undoButton.addEventListener(BaseButtonEvent.HANDLE_RELEASE, onUndoRelease);
			saveButton.addEventListener(BaseButtonEvent.HANDLE_RELEASE, onSendCookie);
			
			anotherCookieButton.addEventListener(BaseButtonEvent.HANDLE_OUT, onButtonOut);
			decorateButton.addEventListener(BaseButtonEvent.HANDLE_OUT, onButtonOut);
			sendButton.addEventListener(BaseButtonEvent.HANDLE_OUT, onButtonOut);
			startButton.addEventListener(BaseButtonEvent.HANDLE_OUT, onButtonOut);
			saveButton.addEventListener(BaseButtonEvent.HANDLE_OUT, onButtonOut);
			
			anotherCookieButton.addEventListener(BaseButtonEvent.HANDLE_OVER, onButtonOver);
			decorateButton.addEventListener(BaseButtonEvent.HANDLE_OVER, onButtonOver);
			sendButton.addEventListener(BaseButtonEvent.HANDLE_OVER, onButtonOver);
			startButton.addEventListener(BaseButtonEvent.HANDLE_OVER, onButtonOver);
			saveButton.addEventListener(BaseButtonEvent.HANDLE_OVER, onButtonOver);
			
			clearButton.addEventListener(BaseButtonEvent.HANDLE_OUT, onClearButtonOut);
			undoButton.addEventListener(BaseButtonEvent.HANDLE_OUT, onUndoButtonOut);
			
			clearButton.addEventListener(BaseButtonEvent.HANDLE_OVER, onClearButtonOver);
			undoButton.addEventListener(BaseButtonEvent.HANDLE_OVER, onUndoButtonOver);
			
			initSend();
		}
		private function changeState(s:String):void {
			if (this.state != "elves") this.lastState = this.state;
			if (this.state != s) this.state = s;
			switch (this.state) {
				case "": drawHome(); break;
				case "decorate": 		drawDecorate(); break;
				case "elves": 			drawElves(); break;
				case "send": 			drawSend(); break;
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
			saveButton.enabled = true;
			TweenLite.to(parchment, 1.5, { y: -parchment.height, ease:Expo.easeOut } );
			TweenLite.to(gingerbreadCookie, 1, { rotation: -11, x:2, y:225, ease:Expo.easeOut } );
			TweenLite.to(sendCopy, 0.6, { autoAlpha:1, delay:0.4 } );
			TweenLite.to(saveButton, 0.6, { autoAlpha:1, delay:0.6 } );
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
			anotherCookieButton.visible = decorateCopy.visible = decorateButton.visible = homeCopy.visible = sendButton.visible = sendCopy.visible = startButton.visible = thankYouCopy.visible = saveButton.visible = errorText.visible = savingText.visible = false;
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
			TweenLite.to(saveButton, 0.6, { autoAlpha:0 } );
			TweenLite.to(errorText, 0.6, { autoAlpha:0 } );
			TweenLite.to(savingText, 0.6, { autoAlpha:0 } );
			TweenLite.to(tag, 1.2, { rotation:0, y:-tag.height, ease:Back.easeOut, onComplete:changeState, onCompleteParams:[nextState] } );
		}
		private function hideThankYou():void {
			TweenLite.to(thankYouCopy, 0.6, { autoAlpha:0 } );
			TweenLite.to(anotherCookieButton, 0.6, { autoAlpha:0, onComplete:changeState, onCompleteParams:[nextState] } );
		}
		private function undoState(s:String):void {
			nextState = s;
			// trace("undo state", nextState)
			switch (state) {
				case "": 				hideHome(); break;
				case "elves": 			hideElves(); break;
				case "decorate": 		hideDecorate(); break;
				case "send": 			hideSend(); break;
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
		private function onStageKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == 83) {
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDown);
				removeChild(ssnow);
				addChild(new SnowStorm());
			}
		}
		private function onResize(e:Event = null):void {
			if (isDecorateDrawn) decorationPanel.y = int(stage.stageHeight - PANEL_TAR_Y);
			else decorationPanel.y = stage.stageHeight + 50;
			decorationPanel.x = int(stage.stageWidth/2-decorationPanel.bg.width/2);
			credit.y = ssnow.y = int(stage.stageHeight - 22);
			ssnow.x=int(stage.stageWidth - 64);
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
			//trace('onSWFAddress', e, s);
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
		private function onDecorateRelease(e:BaseButtonEvent):void { SWFAddress.setValue("/decorate"); }
		private function onSendRelease(e:BaseButtonEvent):void { SWFAddress.setValue("/send"); }
		private function onStartRelease(e:BaseButtonEvent):void { SWFAddress.setValue("/decorate"); }
		
		
		private var sendLoader:URLLoader = new URLLoader();
		private function initSend():void {
		  sendLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
      sendLoader.addEventListener(Event.COMPLETE, onCookieSent);
      sendLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
      sendLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		private function onSendCookie(e:BaseButtonEvent):void {
		    saveButton.enabled = false;
		    var vars = "?key=" + FormData.API_KEY + "&name=android_gingerman&title=Android Gingerman";
        var variables:URLVariables = new URLVariables();
        var request:URLRequest = new URLRequest(FormData.SAVE_PAGE + vars);
        var b:BitmapData = new BitmapData(380, 370, true);
        b.draw(gingerbreadCookie);
        var png:ByteArray = PNGEncoder.encode(b);
        request.contentType = "application/octet-stream";
        request.method = URLRequestMethod.POST;
        request.data = png;
  			TweenLite.to(saveButton, 0.6, { autoAlpha:0 } );
  			TweenLite.to(savingText, 0.6, { autoAlpha:1, delay:.6 } );
        try {
            sendLoader.load(request);
        } catch (err) {
            trace("There was an error processing the gman.", err);
        }
    }
    private function onCookieSent(e:Event):void {
        var res = new XML(unescape(sendLoader.data));
        var variables:URLVariables = new URLVariables();
        var request:URLRequest = new URLRequest("http://twitter.com?status=Check out my android g-man! "+res.links.imgur_page);
        try {            
            navigateToURL(request, "_blank");
        } catch (e:Error) {
            trace('error', e);
        }
        SWFAddress.setValue("/thank-you");
    }
    private function ioErrorHandler(e:IOErrorEvent):void { 
        trace("ioErrorHandler: " + e);
  			TweenLite.to(errorText, 0.6, { autoAlpha:1 } );
  			TweenLite.to(savingText, 0.6, { autoAlpha:0 } );
    }
    private function securityErrorHandler(e:SecurityErrorEvent):void { 
        trace("securityErrorHandler: " + e);
  			TweenLite.to(errorText, 0.6, { autoAlpha:1 } );
  			TweenLite.to(savingText, 0.6, { autoAlpha:0 } );
    }
	}
	
}