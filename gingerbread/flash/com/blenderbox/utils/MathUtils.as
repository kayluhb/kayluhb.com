/**
* @author cbrown
*/
package com.blenderbox.utils 
{
	public class MathUtils 
	{
		public function MathUtils() {
			
		}
		public static function getRandomInt(p_high:Number, p_low:Number):int {
			return Math.floor(Math.random() * (p_high - p_low)) + p_low;
		}
	}
}