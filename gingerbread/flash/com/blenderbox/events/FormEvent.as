package com.blenderbox.events 
{
	import flash.events.Event;
	/**
	 * @author cbrown
	 */
	public class FormEvent extends Event
	{
		public static const SUBMIT:String = "onSubmit";
		
		public function FormEvent(type:String) 
		{
			super(type, false, false);
		}
		
	}
	
}