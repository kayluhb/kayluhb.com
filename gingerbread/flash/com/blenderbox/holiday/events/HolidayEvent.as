package com.blenderbox.holiday.events 
{
	import flash.events.Event;
	
	/**
	 * @author cbrown
	 */
	public class HolidayEvent extends Event
	{
		public static const CLOSE_ELVES:String = "onCloseElves";
		
		public function HolidayEvent(type)
		{
			super(type, false, false);
		}
		
	}
	
}