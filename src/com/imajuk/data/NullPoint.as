package com.imajuk.data 
{
	import flash.geom.Point;
	/**
	 * @author yamaharu
	 */
	public class NullPoint extends Point 
	{
		public function NullPoint ()
		{
			super(NaN, NaN);
		}
	}
}
