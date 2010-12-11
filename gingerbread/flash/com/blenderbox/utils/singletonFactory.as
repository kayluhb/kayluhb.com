/*
 * Author: Richard Lord
 * Copyright (c) Big Room Ventures Ltd. 2007-2008
 * Version: 1.0.0
 * 
 * Licence Agreement
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.blenderbox.utils 
{
	/**
	 * Used to create a singleton from a class without adapting the 
	 * class itself. This function returns the same instance of the
	 * class every time it is called. This function only works with
	 * classes that don't require parameters in the constructor.
	 * 
	 * @param type The class you want a singleton from
	 * 
	 * @return the singleton instance of the class
	 */
	public function singletonFactory( type:Class ):*
	{
		return type in instances ? instances[type] : instances[type] = new type();
	}
}

import flash.utils.Dictionary;
var instances:Dictionary = new Dictionary( false );
