/**
* @author cbrown
*/
package com.blenderbox.utils 
{
	public class DateUtils 
	{
		public static const longMonths:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
		
		public static function getFullMonthName(monthId:Number):String {
			return DateUtils.longMonths[monthId];
		}
	}
}