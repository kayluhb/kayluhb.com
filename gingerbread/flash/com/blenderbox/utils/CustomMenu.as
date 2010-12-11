/**
* @author cbrown
*/
package com.blenderbox.utils 
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.ui.*;

	public class CustomMenu {
		
		public function CustomMenu(sprite:Sprite, showBBOX:Boolean = true) {
			var newMenu:ContextMenu = new ContextMenu();
			newMenu.hideBuiltInItems();
			if (showBBOX) {
				var bboxItem:ContextMenuItem = new ContextMenuItem("design and technology by blenderbox");
				bboxItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onItemSelect); 
				newMenu.customItems.push(bboxItem);
			}
			sprite.contextMenu = newMenu;
		}
		// event handlers
		private function onItemSelect(event:ContextMenuEvent):void { 
			navigateToURL(new URLRequest("http://www.blenderbox.com"), "_blank");
		}
	}
}