/* 
 * Author: Richard Lord
 * Copyright (c) Big Room Ventures Ltd. 2007
 * Version 1.0.0
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

package com.blenderbox.display 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	/**
	 * Creates and manages a circular perlin noise effect.
	 * 
	 * <p>This class maps a linear perlin noise to a radial perlin noise and exposes the 
	 * resulting bitmapdata for use.
	 * 
	 * --------------------------------------------------------------------------------
	 * 
	 * To use:
	 * 
	 * var perlin:RadialPerlin = new RadialPerlin( radius:Number,
	 *                                             numOctaves:uint,
	 *                                             randomSeed:int,
	 *                                             fractalNoise:Boolean,
	 *                                             channelOptions:uint, 
	 *                                             grayScale:Boolean, 
	 *                                             fadeToEdge:Boolean );
	 * perlin.draw( offsetDistance:Number, offsetRotation:Number [in degrees] );
	 * perlin.bitmapData - the bitmap data created by the draw method
	 * 
	 * e.g.
	 * var perlin:RadialPerlin = new RadialPerlin( 100, 3, Math.random() * 1000, false, 15, false, true );
	 * perlin.draw( 0, 0 );
	 * var bmp:Bitmap = new Bitmap( perlin.bitmapData );
	 * addChild( bmp );
	 * 
	 * --------------------------------------------------------------------------------
	 */
	public class RadialPerlin 
	{
		private var bitmap:BitmapData; // the radial bitmap
		private var perlin:BitmapData; // normal perlin bitmap
		private var radius:uint; // radius of the bitmap
		private var perlinWidth:uint; // width of the perlin bitmap
		private var numOctaves:uint; // number of octaves in the perlin noise
		private var randomSeed:uint; // seed for the perlin noise
		private var fractalNoise:Boolean; // fractal noise state for the perlin noise
		private var channelOptions:uint; // channel options for the perlin noise
		private var grayScale:Boolean; // grayscale setting for the perlin noise
		private var fadeEdge:Boolean; // to fade the image towards the edge or not
		
		private static const twoPi:Number = 2 * Math.PI; // constant for speed
		
		/**
		 * The constructor creates a Radialperlin effect.
		 * 
		 * @param radius The radius of the perlin noise image
		 * @param numOctaves Number of octaves or individual noise functions to combine to create this noise. Larger numbers of 
		 * octaves create images with greater detail. Larger numbers of octaves also require more processing time.
		 * @param randomSeed The random seed number to use. If you keep all other parameters the same, you can generate different 
		 * pseudo-random results by varying the random seed value. The Perlin noise function is a mapping function, not a true 
		 * random-number generation function, so it creates the same results each time from the same random seed.
		 * @param fractalNoise A Boolean value. If the value is true, the method generates fractal noise; otherwise, it generates 
		 * turbulence. An image with turbulence has visible discontinuities in the gradient that can make it better approximate 
		 * sharper visual effects like flames and ocean waves.
		 * @param channelOptions A number that can be a combination of any of the four color channel values (BitmapDataChannel.RED, 
		 * BitmapDataChannel.BLUE, BitmapDataChannel.GREEN, and BitmapDataChannel.ALPHA). You can use the logical OR operator (|) 
		 * to combine channel values.
		 * @param greyScale A Boolean value. If the value is true, a grayscale image is created by setting each of the red, green, 
		 * and blue color channels to identical values. The alpha channel value is not affected if this value is set to true.
		 * @param fadeEdge Indicates whether to fade the edge of the image to transparent (true) or keep a sharpe edge on the 
		 * image (false).
		 */
		public function RadialPerlin( radius:Number, numOctaves:uint, randomSeed:int, fractalNoise:Boolean,
									channelOptions:uint = 7, grayScale:Boolean = false, fadeEdge:Boolean = false )
		{
			// set our properties
			this.radius = Math.ceil( radius );
			this.fadeEdge = fadeEdge;
			this.numOctaves = numOctaves;
			this.randomSeed = randomSeed;
			this.fractalNoise = fractalNoise;
			this.channelOptions = channelOptions;
			this.grayScale = grayScale;
			perlinWidth = Math.ceil( radius * twoPi );
			
			// create the bitmaps
			bitmap = new BitmapData( 2 * radius, 2 * radius, true, 0 );
			perlin = new BitmapData( radius, perlinWidth, true, 0 );
		}
		
		// to draw in the bitmapData
		public function draw( pDistance:Number, pRotation:Number ):void
		{
			// create the perlin noise
			var rotation:Number = -pRotation * Math.PI / 180;
			var offset:Point = new Point( -pDistance, 0 );
			var offsets:Array = new Array();
			for ( var i:Number = numOctaves; i--; )
			{
				offsets.push( offset );
			}
			perlin.perlinNoise( radius, perlinWidth, numOctaves, randomSeed, true, fractalNoise, channelOptions, grayScale, offsets );
			
			// map the perlin noise to our circle
			for ( var x:Number = -radius + 0.5; x < radius; ++x )
			{
				for ( var y:Number = -radius + 0.5; y < radius; ++y )
				{
					var distance:Number = x * x + y * y;
					if ( distance <= radius * radius )
					{
						distance = Math.sqrt( distance );
						var angle:Number = Math.atan2( y, x ) + rotation;
						// restrict angle between 0 and twoPi
						while ( angle < 0 )
						{
							angle += twoPi;
						}
						while ( angle >= twoPi )
						{
							angle -= twoPi;
						}
						// read the pixel colour out of the perlin bitmap
						var colour:Number = perlin.getPixel32( distance, angle * radius );
						// add alpha fade to edge;
						if ( fadeEdge )
						{
							var alpha:Number = colour >>> 24;
							alpha *= (radius - distance) / radius;
							colour = ( colour & 0xFFFFFF ) | ( alpha << 24 );
						}
						// set the pixel colour in the bitmap
						bitmap.setPixel32( x + radius - 0.5, y + radius - 0.5, colour );
					}
				}
			}
		}
		
		public function get bitmapData():BitmapData
		{
			return bitmap;
		}
		
		public function dispose():void
		{
			perlin.dispose();
			bitmap.dispose();
		}
	}
}
