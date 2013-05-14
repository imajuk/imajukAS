package com.imajuk.data {
	import com.imajuk.data.IArray2DIterator;		/**
	 * @author yamaharu
	 */
	public class RoundHalfIterator extends Array2DIterator implements IArray2DIterator 	{		public function RoundHalfIterator (__array2D : Array2D) 		{			super(__array2D);			myArray = new Array();			var x : int = 0;			var y : int = 1;			var a : Array2D = __array2D;			while(x < a.cols)			{				myArray.push(a.getElement(x ++, 0));			}			while(y < a.rows)			{				myArray.push(a.getElement(a.cols - 1, y ++));			}		}
								public override function get cursorX () : int		{			return 0;		}								public override function get cursorY () : int		{			return 0;		}	}
}
