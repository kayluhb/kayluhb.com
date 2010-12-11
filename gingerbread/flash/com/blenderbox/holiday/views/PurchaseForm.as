package com.blenderbox.holiday.views 
{
	import com.adobe.images.PNGEncoder;
	import com.blenderbox.events.*;
	import com.blenderbox.holiday.Card;
	import com.blenderbox.holiday.models.FormData;
	import com.blenderbox.ui.InputField;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.ByteArray;
	
	/**
	 * @author cbrown
	 */
	public class PurchaseForm extends MovieClip
	{
		private var fields:Array;
		private var saveLoader:URLLoader = new URLLoader();
		private var purchaseLoader:URLLoader = new URLLoader();
		
		public function PurchaseForm() 
		{
			fields = [yourName, yourEmail, recipientName, recipientEmail, address, city, state, zip, message];
			addListeners();
			initUI();
		}
		// publics
		public function disable():void {
			payPalButton.enabled = false;
		}
		public function enable():void {
			payPalButton.enabled = true;
		}
		public function reset():void {
			recipientName.defaultText = FormData.RECIPIENT_NAME;
			recipientEmail.defaultText = FormData.RECIPIENT_EMAIL;
			address.defaultText = FormData.ADDRESS
			city.defaultText = FormData.CITY;
			state.defaultText = FormData.STATE;
			zip.defaultText = FormData.ZIP;
			message.defaultText = FormData.MESSAGE;
		}
		// privates
		private function addListeners():void {
			purchaseLoader.dataFormat = saveLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
			purchaseLoader.addEventListener(Event.COMPLETE, onCookiePurchased);
			purchaseLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			purchaseLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			saveLoader.addEventListener(Event.COMPLETE, onCookieSaved);
			saveLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			saveLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		private function initUI():void {
			reset();
			
			yourName.defaultText = FormData.YOUR_NAME;
			yourEmail.defaultText = FormData.YOUR_EMAIL;
			
			yourName.errorText = FormData.YOUR_NAME_ERROR;
			yourEmail.errorText = FormData.YOUR_EMAIL_ERROR;
			recipientName.errorText = FormData.RECIPIENT_NAME_ERROR;
			recipientEmail.errorText = FormData.RECIPIENT_EMAIL_ERROR;
			address.errorText = FormData.ADDRESS_ERROR;
			city.errorText = FormData.CITY_ERROR;
			state.errorText = FormData.STATE_ERROR;
			zip.errorText = FormData.ZIP_ERROR;
			
			yourEmail.isEmail = true;
			recipientEmail.isEmail = true;
			message.isRequired = false;
			zip.isNumbersOnly = true;
			
			for (var i:Number = 0; i < fields.length; ++i) {
				fields[i].index = i;
				fields[i].addEventListener(FormEvent.SUBMIT, onSubmitEnter);
			}
			
			payPalButton.addEventListener(BaseButtonEvent.HANDLE_RELEASE, onSubmitRelease);
		}
		private function submitForm():void {
			trace("submit form", FormData.SAVE_PAGE);
			var card:Card = this.parent as Card;
			var gingerbreadCookie = card.gingerbreadCookie;
			var request:URLRequest = new URLRequest(FormData.SAVE_PAGE);
			disable();
			request.contentType = "application/octet-stream";
			request.method = URLRequestMethod.POST;
			try {
				var b:BitmapData = new BitmapData(277, 346, true);
				b.draw(gingerbreadCookie);
				var png:ByteArray = PNGEncoder.encode(b);
				request.data = png;
				saveLoader.load(request);
			} catch (err) {
				//handle upload error
				trace("There was an error processing the gman.", err);
			}
		}
		// event handlers
		private function onCookieSaved(e:Event):void {
			try {
				trace("onCookieSaved:", saveLoader.data, "now post to:", FormData.PURCHASE_PAGE);
				var urlVariables:URLVariables = new URLVariables();
				var request:URLRequest = new URLRequest(FormData.PURCHASE_PAGE);
				urlVariables.yourName = yourName.value;
				urlVariables.yourEmail = yourEmail.value
				urlVariables.recipientName = recipientName.value;
				urlVariables.recipientEmail = recipientEmail.value;
				urlVariables.message = message.value;
				urlVariables.address = address.value;
				urlVariables.city = city.value;
				urlVariables.state = state.value;
				urlVariables.zip = zip.value;
				urlVariables.id = saveLoader.data.id;
				request.method = URLRequestMethod.POST;
				request.data = urlVariables;
				
				purchaseLoader.load(request);
			} catch (err) {
				//handle upload error
				trace("There was an error purchasing the gman.", err);
			}
		}
		private function onCookiePurchased(e:Event):void {
			trace("onCookiePurchased:", "cookie purchase created, open paypal", FormData.PAYPAL_PAGE, "?id=" + purchaseLoader.data.id);
			navigateToURL(new URLRequest(FormData.PAYPAL_PAGE + "?id=" + purchaseLoader.data.id), "_self");
		}
		private function onSubmitRelease(e:BaseButtonEvent = null):void {
			var error:Boolean = false;
			for (var i:Number = 0; i < fields.length; ++i) {
				error = fields[i].hasError || error;
			}
			if (!error) submitForm();
		}
		private function onSubmitEnter(e:FormEvent):void {
			onSubmitRelease();
		}
		
		private function securityErrorHandler(e:SecurityErrorEvent):void { 
			trace("securityErrorHandler: " + e);
			enable();
		}
        private function ioErrorHandler(e:IOErrorEvent):void { 
			trace("ioErrorHandler: " + e);
			enable();
		}
	}
	
}